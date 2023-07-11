# Using resholve's Nix API
resholve replaces bare references (subject to a PATH search at runtime) to external commands and scripts with absolute paths.

This small super-power helps ensure script dependencies are declared, present, and don't unexpectedly shift when the PATH changes.

resholve is developed to enable the Nix package manager to package and integrate Shell projects, but its features are not Nix-specific and inevitably have other applications.

<!-- generated from resholve's repo; best to suggest edits there (or at least notify me) -->

This will hopefully make its way into the Nixpkgs manual soon, but
until then I'll outline how to use the functions:
- `resholve.mkDerivation` (formerly `resholvePackage`)
- `resholve.writeScript` (formerly `resholveScript`)
- `resholve.writeScriptBin` (formerly `resholveScriptBin`)
- `resholve.phraseSolution` (new in resholve 0.8.0)

> Fair warning: resholve does *not* aspire to resolving all valid Shell
> scripts. It depends on the OSH/Oil parser, which aims to support most (but
> not all) Bash. resholve aims to be a ~90% sort of solution.

## API Concepts

The main difference between `resholve.mkDerivation` and other builder functions
is the `solutions` attrset, which describes which scripts to resolve and how.
Each "solution" (k=v pair) in this attrset describes one resholve invocation.

> NOTE: For most shell packages, one invocation will probably be enough:
> - Packages with a single script will only need one solution.
> - Packages with multiple scripts can still use one solution if the scripts
>   don't require conflicting directives.
> - Packages with scripts that require conflicting directives can use multiple
>   solutions to resolve the scripts separately, but produce a single package.

`resholve.writeScript` and `resholve.writeScriptBin` support a _single_
`solution` attrset. This is basically the same as any single solution in `resholve.mkDerivation`, except that it doesn't need a `scripts` attr (it is automatically added). `resholve.phraseSolution` also only accepts a single solution--but it _does_ still require the `scripts` attr.

## Basic `resholve.mkDerivation` Example

Here's a simple example of how `resholve.mkDerivation` is already used in nixpkgs:

<!-- TODO: figure out how to pull this externally? -->

```nix
{ lib
, fetchFromGitHub
, resholve
, substituteAll
, bash
, coreutils
, goss
, which
}:

resholve.mkDerivation rec {
  pname = "dgoss";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "aelsabbahy";
    repo = "goss";
    rev = "v${version}";
    sha256 = "01ssc7rnnwpyhjv96qy8drsskghbfpyxpsahk8s62lh8pxygynhv";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    sed -i '2i GOSS_PATH=${goss}/bin/goss' extras/dgoss/dgoss
    install -D extras/dgoss/dgoss $out/bin/dgoss
  '';

  solutions = {
    default = {
      scripts = [ "bin/dgoss" ];
      interpreter = "${bash}/bin/bash";
      inputs = [ coreutils which ];
      keep = {
        "$CONTAINER_RUNTIME" = true;
      };
    };
  };

  meta = with lib; {
    homepage = "https://github.com/aelsabbahy/goss/blob/v${version}/extras/dgoss/README.md";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual ];
  };
}
```


## Basic `resholve.writeScript` and `resholve.writeScriptBin` examples

Both of these functions have the same basic API. The examples are a little
trivial, so I'll also link to some real-world examples:
- [shell.nix from abathur/tdverpy](https://github.com/abathur/tdverpy/blob/e1f956df3ed1c7097a5164e0c85b178772e277f5/shell.nix#L6-L13)

```nix
resholvedScript = resholve.writeScript "name" {
    inputs = [ file ];
    interpreter = "${bash}/bin/bash";
  } ''
    echo "Hello"
    file .
  '';
resholvedScriptBin = resholve.writeScriptBin "name" {
    inputs = [ file ];
    interpreter = "${bash}/bin/bash";
  } ''
    echo "Hello"
    file .
  '';
```


## Basic `resholve.phraseSolution` example

This function has a similar API to `writeScript` and `writeScriptBin`, except it does require a `scripts` attr. It is intended to make resholve a little easier to mix into more types of build. This example is a little
trivial for now. If you have a real usage that you find helpful, please PR it.

```nix
{ stdenv, resholve, module1 }:

stdenv.mkDerivation {
  # pname = "testmod3";
  # version = "unreleased";
  # src = ...;

  installPhase = ''
    mkdir -p $out/bin
    install conjure.sh $out/bin/conjure.sh
    ${resholve.phraseSolution "conjure" {
      scripts = [ "bin/conjure.sh" ];
      interpreter = "${bash}/bin/bash";
      inputs = [ module1 ];
      fake = {
        external = [ "jq" "openssl" ];
      };
    }}
  '';
}
```


## Options

`resholve.mkDerivation` maps Nix types/idioms into the flags and environment variables
that the `resholve` CLI expects. Here's an overview:

| Option | Type | Containing |
|--------|------|------------|
| scripts | `<list>` | scripts to resolve (`$out`-relative paths) |
| interpreter | `"none"` `<path>` | The absolute interpreter `<path>` for the script's shebang. The special value `none` ensures there is no shebang. |
| inputs | `<packages>` | Packages to resolve external dependencies from. |
| fake | `<directives>` | pretend some commands exist |
| fix | `<directives>` | fix things we can't auto-fix/ignore |
| keep | `<directives>` | keep things we can't auto-fix/ignore |
| lore | `<directory>` | control nested resolution |
| execer | `<statements>` | modify nested resolution |
| wrapper | `<statements>` | modify nested resolution |
| prologue | `<file>` | insert file before resolved script |
| epilogue | `<file>` | insert file after resolved script |

<!-- TODO: section below is largely custom for nixpkgs, but I would LIKE to wurst it. -->

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
   - force resholve to resolve known security wrappers
3. `keep` directives tell resholve not to raise an error (i.e., ignore)
   something it would usually object to. Common examples:
   - variables used as/within the first word of a command
   - pre-existing absolute or user-relative (~) command paths
   - dynamic (variable) arguments to commands known to accept/run other commands

> NOTE: resholve has a (growing) number of directives detailed in `man resholve`
> via `nixpkgs.resholve` (though protections against run-time use of python2 in nixpkgs mean you'll have to set `NIXPKGS_ALLOW_INSECURE=1` to pull resholve into nix-shell).

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
  or might execute its arguments. Every "can" or "might" verdict requires:
  - an update to the matching rules in [binlore](https://github.com/abathur/binlore)
    if there's absolutely no exec in the executable and binlore just lacks
    rules for understanding this
  - an override in [binlore](https://github.com/abathur/binlore) if there is
    exec but it isn't actually under user control
  - a parser in [resholve](https://github.com/abathur/resholve) capable of
    isolating the exec'd words if the command does have exec under user
    control
  - overriding the execer lore for the executable if manual triage indicates
    that all of the invocations in the current package don't include any
    commands that the executable would exec
  - if manual triage turns up any commands that would be exec'd, use some
    non-resholve tool to patch/substitute/replace them before or after you
    run resholve on them (if before, you may need to also add keep directives
    for these absolute paths)

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

```nix
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
wrapper = [
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
