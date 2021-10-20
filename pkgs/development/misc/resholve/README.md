# Using resholve's Nix API

resholve converts bare executable references in shell scripts to absolute
paths. This will hopefully make its way into the Nixpkgs manual soon, but
until then I'll outline how to use the `resholvePackage`, `resholveScript`,
and `resholveScriptBin` functions.

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

The `resholveScript` and `resholveScriptBin` functions support a _single_
`solution` attrset. This is basically the same as any single solution in `resholvePackage`, except that it doesn't need a `scripts` attr (it is automatically added).

## Basic `resholvePackage` Example

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

## Basic `resholveScript` and `resholveScriptBin` examples

Both of these functions have the same basic API. This example is a little
trivial for now. If you have a real usage that you find helpful, please PR it.

```nix
resholvedScript = resholveScript "name" {
    inputs = [ file ];
    interpreter = "${bash}/bin/bash";
  } ''
    echo "Hello"
    file .
  '';
resholvedScriptBin = resholveScriptBin "name" {
    inputs = [ file ];
    interpreter = "${bash}/bin/bash";
  } ''
    echo "Hello"
    file .
  '';
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
| epilogue      | file    | text to insert after the last code-line               |
| flags         | list    | strings to pass as flags                              |
| fake          | attrset | [directives](#controlling-resolution-with-directives) |
| fix           | attrset | [directives](#controlling-resolution-with-directives) |
| keep          | attrset | [directives](#controlling-resolution-with-directives) |
| lore          | string  | [lore directory](#controlling-nested-resolution-with-lore)  |
| execers       | list    | [execer lore directive](#controlling-nested-resolution-with-lore) |
| wrappers      | list    | [wrapper lore directive](#controlling-nested-resolution-with-lore) |

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
  # fake accepts the initial of valid identifier types as a CLI convenience.
  # Use full names in the Nix API.
  function = [ "setUp" "tearDown" ];
  builtin = [ "setopt" ];
  source = [ "/etc/bashrc" ];
};

# --fix 'aliases $GIT:gix /bin/bash'
fix = {
  # all single-word directives use `true` as value
  aliases = true;
  "$GIT" = [ "gix" ];
  "/bin/bash";
};

# --keep 'source:$HOME /etc/bashrc ~/.bashrc'
keep = {
  source = [ "$HOME" ];
  "/etc/bashrc" = true;
  "~/.bashrc" = true;
};
```

> **Note:** For now, at least, you'll need to reference the manpage to completely understand these examples.

## Controlling nested resolution with lore

Initially, resolution of commands in the arguments to command-executing
commands was limited to one level for a hard-coded list of builtins and
external commands. resholve can now resolve these recursively.

This feature combines information (_lore_) that the resholve Nix API
obtains via binlore ([nixpkgs](../../tools/analysis/binlore), [repo](https://github.com/abathur/resholve)),
with some rules (internal to resholve) for locating sub-executions in
some of the more common commands.

- "execer" lore identifies whether an executable can, cannot,
  or might execute its arguments. Every "can" or "might" verdict requires
  either built-in rules for finding the executable, or human triage.
- "wrapper" lore maps shell exec wrappers to the programs they exec so
  that resholve can substitute an executable's verdict for its wrapper's.

> **Caution:** At least when it comes to common utilities, it's best to treat
> overrides as a stopgap until they can be properly handled in resholve and/or
> binlore. Please report things you have to override and, if possible, help
> get them sorted.

There will be more mechanisms for controlling this process in the future
(and your reports/experiences will play a role in shaping them...) For now,
the main lever is the ability to substitute your own lore. This is how you'd
do it piecemeal:

```
# --execer 'cannot:${openssl.bin}/bin/openssl can:${openssl.bin}/bin/c_rehash'
execer = [
  /*
    This is the same verdict binlore will
    come up with. It's a no-op just to demo
    how to fiddle lore via the Nix API.
  */
  "cannot:${openssl.bin}/bin/openssl"
  # different verdict, but not used
  "can:${openssl.bin}/bin/c_rehash"
];

# --wrapper '${gnugrep}/bin/egrep:${gnugrep}/bin/grep'
execer = [
  /*
    This is the same verdict binlore will
    come up with. It's a no-op just to demo
    how to fiddle lore via the Nix API.
  */
  "${gnugrep}/bin/egrep:${gnugrep}/bin/grep"
];
```

The format is fairly simple to generate--you can script your own generator if
you need to modify the lore.
