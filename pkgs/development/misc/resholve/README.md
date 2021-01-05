# Using resholve's Nix API

resholve converts bare executable references in shell scripts to absolute
paths. This will hopefully make its way into the Nixpkgs manual soon, but
until then I'll outline how to use the `resholvePackage` function.

> Fair warning: resholve does *not* aspire to resolving all valid Shell
> scripts. It depends on the OSH/Oil parser, which aims to support most (but
> not all) Bash, and aims to be a ~90% sort of solution.

Let's start with a simple example from one of my own projects:

```nix
{ stdenv, lib, resholvePackage, fetchFromGitHub, bashup-events44, bashInteractive_5, doCheck ? true, shellcheck }:

resholvePackage rec {
  pname = "shellswain";
  version = "unreleased";

  src = fetchFromGitHub {
    # ...
  };

  solutions = {
    profile = {
      # the only *required* arguments
      scripts = [ "bin/shellswain.bash" ];
      interpreter = "none";
      inputs = [ bashup-events44 ];
    };
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  inherit doCheck;
  checkInputs = [ shellcheck ];

  # ...
}
```

I'll focus on the `solutions` attribute, since this is the only part
that differs from other derivations.

Each "solution" (k=v pair)
describes one resholve invocation. For most shell packages, one
invocation will probably be enough. resholve will make you be very
explicit about your script's dependencies, and it may also need your
help sorting out some references or problems that it can't safely
handle on its own.

If you have more than one script, and your scripts need conflicting
directives, you can specify more than one solution to resolve the
scripts separately, but still produce a single package.

Let's take a closer look:

```nix
  solutions = {
    # each solution has a short name; this is what you'd use to
    # override the settings of this solution, and it may also show up
    # in (some) error messages.
    profile = {
      # specify one or more $out-relative script paths (unlike many
      # builders, resholve will modify the output files during fixup
      # to correctly resolve scripts that source within the package)
      scripts = [ "bin/shellswain.bash" ];
      # "none" for no shebang, "${bash}/bin/bash" for bash, etc.
      interpreter = "none";
      # packages resholve should resolve executables from
      inputs = [ bashup-events44 ];
    };
  };
```

resholve has a (growing) number of options for handling more complex
scripts. I won't cover these in excruciating detail here. You can find
more information about these in `man resholve` via `nixpkgs.resholve`.

Instead, we'll look at the general form of the solutions attrset:

```nix
solutions = {
  shortname = {
    # required
    # $out-relative paths to try resolving
    scripts = [ "bin/shunit2" ];
    # packages to resolve executables from
    inputs = [ coreutils gnused gnugrep findutils ];
    # path for shebang, or 'none' to omit shebang
    interpreter = "${bash}/bin/bash";

    # optional
    fake = { fake directives };
    fix = { fix directives };
    keep = { keep directives };
    # file to inject before first code-line of script
    prologue = file;
    # file to inject after last code-line of script
    epilogue = file;
    # extra command-line flags passed to resholve; generally this API
    # should align with what resholve supports, but flags may help if
    # you need to override the version of resholve.
    flags = [ ];
  };
};
```

The main way you'll adjust how resholve handles your scripts are the
fake, fix, and keep directives. The manpage covers their purpose and
how to format them on the command-line, so I'll focus on how you'll
need to translate them into Nix types.

```nix
# --fake 'f:setUp;tearDown builtin:setopt source:/etc/bashrc'
fake = {
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
