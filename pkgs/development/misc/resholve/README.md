# Using resholve's Nix API

resholve converts bare executable references in shell scripts to absolute
paths. This will hopefully make its way into the Nixpkgs manual soon, but
until then I'll outline how to use the `resholvePackage` function.

> Fair warning: resholve does *not* aspire to resolving all valid Shell
> scripts. It depends on the OSH/Oil parser, which aims to support most (but
> not all) Bash. resholve aims to be a ~90% sort of solution.

## API Concepts

The main difference between `resholvePackage` and other builder functions
is the `solutions` attrset, which describes which scripts to resolve and how.
Each "solution" (k=v pair) in this attrset describes one resholve invocation.

> NOTE: For most shell packages, one invocation will probably be enough:
> - Packages with a single script will only need one solution.
> - Packages with multiple scripts can still use one solution if the scripts
>   don't require conflicting directives.
> - Packages with scripts that require conflicting directives can use multiple
>   solutions to resolve the scripts separately, but produce a single package.

## Basic Example

Here's a simple example from one of my own projects, with annotations:
<!--
TODO: ideally this will use a nixpkgs example; but we don't have any IN yet
and the first package PR (bashup-events) is too complex for this context.
-->

```nix
{ stdenv, lib, resholvePackage, fetchFromGitHub, bashup-events44, bashInteractive_5, doCheck ? true, shellcheck }:

resholvePackage rec {
  pname = "shellswain";
  version = "unreleased";

  src = fetchFromGitHub {
    # ...
  };

  solutions = {
    # Give each solution a short name. This is what you'd use to
    # override its settings, and it shows in (some) error messages.
    profile = {
      # the only *required* arguments are the 3 below

      # Specify 1 or more $out-relative script paths. Unlike many
      # builders, resholvePackage modifies the output files during
      # fixup (to correctly resolve in-package sourcing).
      scripts = [ "bin/shellswain.bash" ];

      # "none" for no shebang, "${bash}/bin/bash" for bash, etc.
      interpreter = "none";

      # packages resholve should resolve executables from
      inputs = [ bashup-events44 ];
    };
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  inherit doCheck;
  checkInputs = [ shellcheck ];

  # ...
}
```

## Options

`resholvePackage` maps Nix types/idioms into the flags and environment variables
that the `resholve` CLI expects. Here's an overview:

| Option        | Type    | Containing                                            |
| ------------- | ------- | ----------------------------------------------------- |
| scripts       | list    | $out-relative string paths to resolve                 |
| inputs        | list    | packages to resolve executables from                  |
| interpreter   | string  | 'none' or abspath for shebang                         |
| prologue      | file    | text to insert before the first code-line             |
| epilogue      | file    | text to isnert after the last code-line               |
| flags         | list    | strings to pass as flags                              |
| fake          | attrset | [directives](#controlling-resolution-with-directives) |
| fix           | attrset | [directives](#controlling-resolution-with-directives) |
| keep          | attrset | [directives](#controlling-resolution-with-directives) |

## Controlling resolution with directives

In order to resolve a script, resholve will make you disambiguate how it should
handle any potential problems it encounters with directives. There are currently
3 types:
1. `fake` directives tell resholve to pretend it knows about an identifier
   such as a function, builtin, external command, etc. if there's a good reason
   it doesn't already know about it. Common examples:
   - builtins for a non-bash shell
   - loadable builtins
   - platform-specific external commands in cross-platform conditionals
2. `fix` directives give resholve permission to fix something that it can't
   safely fix automatically. Common examples:
   - resolving commands in aliases (this is appropriate for standalone scripts
     that use aliases non-interactively--but it would prevent profile/rc
     scripts from using the latest current-system symlinks.)
   - resolve commands in a variable definition
   - resolve an absolute command path from inputs as if it were a bare reference
3. `keep` directives tell resholve not to raise an error (i.e., ignore)
   something it would usually object to. Common examples:
   - variables used as/within the first word of a command
   - pre-existing absolute or user-relative (~) command paths
   - dynamic (variable) arguments to commands known to accept/run other commands

> NOTE: resholve has a (growing) number of directives detailed in `man resholve`
> via `nixpkgs.resholve`.

Each of these 3 types is represented by its own attrset, where you can think
of the key as a scope. The value should be:
- `true` for any directives that the resholve CLI accepts as a single word
- a list of strings for all other options
<!--
TODO: these should be fully-documented here, but I'm already maintaining
more copies of their specification/behavior than I like, and continuing to
add more at this early date will only ensure that I spend more time updating
docs and less time filling in feature gaps.

Full documentation may be greatly accellerated if someone can help me sort out
single-sourcing. See: https://github.com/abathur/resholve/issues/19
-->

This will hopefully make more sense when you see it. Here are CLI examples
from the manpage, and the Nix equivalents:

```nix
# --fake 'f:setUp;tearDown builtin:setopt source:/etc/bashrc'
fake = {
  # fake accepts the initial of valid identifier types as a CLI convienience.
  # Use full names in the Nix API.
  function = [ "setUp" "tearDown" ];
  builtin = [ "setopt" ];
  source = [ "/etc/bashrc" ];
};

# --fix 'aliases xargs:ls $GIT:gix'
fix = {
  # all single-word directives use `true` as value
  aliases = true;
  xargs = [ "ls" ];
  "$GIT" = [ "gix" ];
};

# --keep 'which:git;ls .:$HOME $LS:exa /etc/bashrc ~/.bashrc'
keep = {
  which = [ "git" "ls" ];
  "." = [ "$HOME" ];
  "$LS" = [ "exa" ];
  "/etc/bashrc" = true;
  "~/.bashrc" = true;
};
```
