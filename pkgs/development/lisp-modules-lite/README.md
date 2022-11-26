<details>
<summary>

## Total beginner’s guide

</summary>

Completely baffled by Nix? By Lisp? Do you see a bunch of letter spaghetti and wonder, why would anybody care about this? Me too, friend. Me too.

The worlds of Lisp and Nix are both independently confusing and idiosynratic. It’s a match made in hell.

### Practical example

For a practical example:

1. Copy [examples/make-binary](examples/make-binary) to a fresh directory.

2. Change the top lines in default.nix from:

```nix
{ pkgs ? import .... }:

with pkgs.lispPackagesLite;
```

into:

```nix
{ pkgs ? import <nixpkgs> {} }:

with rec {
  hPkgsSrc = pkgs.fetchFromGitHub {
    owner = "hraban";
    repo = "nixpkgs";
    # replace these two lines with the output of
    # nix run nixpkgs#nix-prefetch-github -- --rev feat/lisp-packages-lite hraban nixpkgs --nix | grep 'rev\|sha'
    rev = "0000000000000000000000000000000000000000";
    sha256 = "";
  };
  lispPackagesLite = (import hPkgsSrc {}).lispPackagesLite.override {
    inherit pkgs;
  };
};

with lispPackagesLite;
```

3. Run the following command:

```sh
nix run nixpkgs#nix-prefetch-github -- --nix --rev feat/lisp-packages-lite hraban nixpkgs | grep 'rev\|sha'
```

Grab the two lines of output, and replace their corresponding lines in the snippet you just pasted, in step 2.

4. Run `nix-build`

5. Done. You should have your binary in `result/bin/demo`. Feel free to mess around in the source files and rebuild.

### Nix

Nix, at its core, is a *programming language* that lets you implement every step of a build system: from fetching the source, to building it, to installing it on your system. There is a huge central repository of many such packages across many programming languages, and their compilers, and tools, etc, all implemented in Nix: that’s “nixpkgs”. It contains e.g. GCC, which lets you build other apps, but it also contains useful functions like `lib.fetchFromGitHub`.

People have taken this (too) far. They’ve built an entire Operating System in Nix. It’s NixOS. It started out as an experiment but it’s here to stay. However it is completely unrelated from this entire project: whether you use Nix on your Mac, Windows, existing Linux computer, or NixOS: this project just helps you build Common Lisp projects. And their dependencies.

There you have it:

- Nix: the language. Compare to Python without stdlib, or raw C without even `#include <stdlib.h>`
- nixpkgs: A giant repository of useful helper functions and all conceivable software in the world for every language, in one. The cornerstone of any useful Nix project.
- NixOS: Cool but unrelated.

### Lisp

Common Lisp is a very old family of Lisp, predating C, that managed to stay relevant and modern. Other, completely unrelated lisps, are Clojure (modern) and Emacs Lisp (also old but still relevant).

This entire project is purely about Common Lisp and has nothing to do with the others.

Common Lisp has many different implementations, and its spec is notoriously reticent to define any implementation details. In fact, the spec says nothing about the concept of packages, bundling, compilation (some but very little), “binaries”, etc.

### ASDF

ASDF is a build system for Common Lisp, but not a package repository. It specifies all the “sane” things a normal, ⅯⅯth century programming language should have: from “which file has which piece of code”, to “which files belong together”, and the ability to bundle them into a single “unit”. The only other language I know of which doesn’t have this built-in is C, or JavaScript (but even that is changing). With ASDF, your code organisation feels more like Python than C. More like Node.JS, less like bare JavaScript.

ASDF is close to a `package.json` file actually: it even has `description`, `version`, `author` fields, etc.

Example ASDF definition:

```common-lisp
(defsystem "hello-lisp"
  :description "hello-lisp: a sample Lisp system."
  :version "0.0.1"
  :author "Joe User <joe@example.com>"
  :licence "Public Domain"
  :depends-on ("optima.ppcre" "command-line-arguments")
  :components ((:file "packages")
               (:file "macros" :depends-on ("packages"))
               (:file "hello" :depends-on ("macros"))))
```

ASDF introduces the concept of “systems”, which you might as well call a “module”. Unfortunately the word “package” already means something very specific (and semi advanced) in Lisp, so just avoid it.

*ASDF does **not** offer a package repository!* That means: it’s not Pip, it’s not NPM, it’s not Maven, etc. ASDF needs you to supply all the code somehow. If you don’t already have all necessary dependencies available on your local hard disk, ASDF can’t help you.

<blockquote>

<details>

<summary>

*Note:* This is not about asdf-vm.com.

</summary>

That’s a recent and completely unrelated project
that helps you manage separate versions of Python, Ruby, etc, all in one
tool. If anything, that’d be more a Nix thing, than a Lisp thing. And to make
matters worse: you can manage Lisp versions using asdf-vm. There was
understandable consternation in the Common Lisp community when they announced
the name and it remains extremely confusing. This is the only thing I’ll say
about that project because it’s 100% unrelated.

</details>

</blockquote>

### A word on Package Repositories

Such an obvious part of any ecosystem, why even question their existence? Package repositories: NPM, Pip, Cargo, Maven, ... what’s the problem? The problem: they are all basically the same thing, reimplemented and reinvented in 99%-similar-1%-different ways. Nix *could* completely obviate the need for package repositories.

Notable language that *doesn’t* have a package repository: Go. In Go, you specify imports directly via the source location in code. It comes with its own baggage, but it’s interesting context. It is no coincidence that vendoring code is very common in Go, compared to other languages.

(“Vendoring”: including your dependencies in your own project’s repository. Think `git add node_modules`.)

Theoretically, Nix makes package repositories obsolete. Specifically: nixpkgs makes package repositories obsolete. More specifically: nixpkgs *is* a package repository.

Practically, most x-language-in-Nix ecosystems are bootstrapped by leveraging their respective existing package repositories. It’s easier for both maintainers and users to just copy all of NPM / Pip / ... into nixpkgs. Maintainers don’t need to worry about where to find each project, or when to update it. Users get a familiar environment. “Oh, this is like NPM / Pip / ..., but with different syntax.”

This lisp-packages-lite project *does* drop the existing Lisp package repository, but that’s only possible because of two peculiarities in the Common Lisp world:

1. Common Lisp code moves slowly, and remains stable for ages. In JavaScript, a package that hasn’t had commits for 2 years is dead. In Common Lisp, it’s completely normal to find and use a package with no commits for >10 years. That means it’s stable. Benefit for lisp-packages-lite: less overhead when maintaining a central repository of "what is every package’s last version?"
2. The Common Lisp ecosystem is relatively small. There are only, what, a few hundred packages? A single human being can maintain it (and he has: Zach Beane maintains the de facto Common Lisp package repository on his own, for >10y now: QuickLisp).

### QuickLisp

Think NPM / Pip for Common Lisp. It is built on top of ASDF. It is a de facto standard. Maintained by Zach Beane. Notable difference: in NPM, all packages are maintained by their respective owners, and updates are published individually. In QuickLisp, Zach sits down every couple of months and fetches the last version of every package, tests them all, and publishes a new version of the entire QuickLisp repository with every package simultaneously updated.

---

Now, back to this project, lisp-packages-lite...

</details>

# Nix Packages Lite

Nix-only implementation of a lispDerivation builder, and registry of popular Common Lisp packages.

This is an experiment to discover what a Lisp-in-Nix system would look like, if QuickLisp didn’t exist. I started with a `stdenv.mkDerivation` and worked my up from there.

## Features / Anti-features

This project has two parts:

1. A lisp derivation builder in Nix ([`default.nix`](default.nix))
2. A registry of the most commonly used Lisp packages ([`packages.nix`](packages.nix))

Together, they offer a "batteries included" build environment for your Lisp project in Nix. This is the same functionality offered by other modules in `nixpkgs`, namely `lispPackages` and `lispPackagesNew`.

The implementation details:

- Tight integration with ASDFv3:
  - tests defined using `test-op`
  - binary output using `:build-operation program-op`
  - regular .asd output (for libraries) by default
  This convention is used by almost every existing major package (literally >99%)
- No QuickLisp (Controversial! I know. See the chapter at the end for more info.)
- All dependency info is manually entered in Nix. No inspection of .asd files, no QuickLisp metadata loaded, etc.
- This project doesn’t touch the Lisp source code at all. No .asd file manging of any kind.
- Supports multi-system source repositories (e.g. `cl-async` exports `cl-async`, `cl-async-ssl`, `cl-async-repl`) with different dependencies
- Fully relies on ASDFv3 for finding systems: no path or system name rewriting in code
- Automatic dependency resolution of all lisp modules
- Automatic “deduplication” of lisp modules in dependency graph (i.e. any source derivation is only ever included once, and all systems for which it’s being loaded are passed in that one single call)

The trade-off is in favour of robustness, at the cost of more human work in managing the Nix derivation definitions.

## Glossary

This package (lisp-modules-lite) makes a distinction between Nix *derivations* and Lisp *systems*:

- **derivation**: A Nix concept. It is a single atomic "block" of "code": it can be just the source code, or a pre-built package ready to use.
- **system**: A Common Lisp (actually an ASDF) concept. It is CL’s closest relative to e.g. a Python "package". Confusingly: Nix also has a concept of system, e.g. `x86_64-darwin`. It’s an OS+Architecture description. Because of that confusion, I try to call a Lisp system `lispSystem` in the code, instead of `system`.
- **package**: Very confusing word which I avoid. It can mean “Lisp package” which is sort-of-but-not-really close to “namespaces” in other languages, or it can mean a Nix derivation. Don’t use this word.

See the [`examples`](examples) directory for demonstrations on how to use this builder.

### 1 Nix derivation, many Lisp systems

A crucial, defining feature of this implementation is that there is only ever *one single Nix derivation per Lisp source code project*. This means *there is **no** 1 ⭤ 1 relationship between Lisp systems and Nix derivations*: if a single piece of code defines multiple systems (as many do; `trivia`, `cl-async`, `babel`, ...) they all still result in a single Nix derivation that exports all of them.

## Usage

### Single derivation

Does your project expose only one Lisp system? You want the simple `lispDerivation` helper function:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite;

lispDerivation {
  lispSystem = "my-system";
  lispDependencies = [ alexandria arrow-macros ];
  src = pkgs.lib.cleanSource ./.;
}
```

If your package defines multiple systems that you want to export, you can define them all:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite;

lispDerivation {
  lispSystems = [ "foo-a" "foo-b" ];
  lispDependencies = [ alexandria arrow-macros ];
  src = pkgs.lib.cleanSource ./.;
}
```

Example for when that makes sense: the `prove` package (a testing framework) used to be called `cl-test-more`. Prove now has two .asd files: `prove.asd` and `cl-test-more.asd`, a compatibility layer. ASDF will only load that file if you tell it explicitly to build `cl-test-more`. Otherwise, it won’t even know to look for it.

Example for when you *don’t* need this: if your main system includes various "private" systems from the same repo explicitly, e.g. via `:depends-on`, you don’t need to tell ASDF about it. It will automatically start looking for them in the current directory. Again, this feature is only useful for “public” systems which are not referenced by the main system. You don’t need it for your `foo-utils.asd` or `foo-test.asd`: just reference them in your `foo.asd` as usual and they will be found.

### Multi-derivation

Does your Lisp project expose multiple separate, different systems, each with different functionality and (in particular) different dependencies?

You have two options:

- "just include all of them" in a single derivation (easiest solution of course), or
- specify separate systems entirely:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite;

lispMultiDerivation {
  systems = {
    foo = {};
    foo-b = {
      lispDependencies = [ alexandria ];
    };
    foo-c = {
      lispSystem = "foo/c";
      lispDependencies = [ foo-b fiveam ];
    };
  };
  src = pkgs.lib.cleanSource ./.;
}
```

Note:
- This evaluates to an attrset with one entry for each system defined in the `systems` set.
- The system name is automatically derived from the attribute key name in the `systems` set.
- You can override it using a `lispSystem` key, as per.
- You can omit `lispDependencies` entirely if you have none.
- You can include other systems defined in the same block, as long as there is no circular dependency chain.
- This is only useful if your separate systems have different lispDependencies. If they don’t, just create a regular `lispDerivation` with `lispSystems = [ "foo-a" "foo-b" ]`.
- You don’t need this for your “internal” packages (see similar note in the previous chapter).
- This is only worth it if the different systems have different dependencies. I use this heavily in [`packages.nix`](packages.nix), because those are libraries and they’re intended for inclusion by other projects. For them, being light-weight matters. But for a personal project, I recommend keeping it all in a single `lispDerivation` and merging all dependencies into a single `lispDependencies`. Far easier.

If this is a dependency in your own project, you’ll want to use it as follows:

foo.nix:
```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite;

lispMultiDerivation {
  systems = {
    foo = {};
    foo-b = {
      lispDependencies = [ alexandria ];
    };
    foo-c = {
      lispSystem = "foo/c";
      lispDependencies = [ foo-b fiveam ];
    };
  };
  src = pkgs.lib.cleanSource ./.;
}
```

bar.nix:

```nix
{
  pkgs ? import <nixpkgs> {},
  foo ? import ./foo { inherit pkgs; }
}:

with pkgs.lispPackagesLite;

lispDerivation {
  lispSystem = "bar";
  src = pkgs.lib.cleanSource ./.;
  lispDependencies = [ foo.foo-b ];
}
```

For real-world examples, peruse [`packages.nix`](packages.nix).

### Use in your existing project

The above snippets assume your entire `<nixpkgs>` is my feature branch, which isn’t realistic nor practical. Here’s a way you can *actually* start using this lisp packages module, today:

```nix
{ pkgs ? import <nixpkgs> {} }:

with rec {
  hPkgsSrc = pkgs.fetchFromGitHub {
    owner = "hraban";
    repo = "nixpkgs";
    # replace these two lines with the output of
    # nix run nixpkgs#nix-prefetch-github -- --rev feat/lisp-packages-lite hraban nixpkgs --nix | grep 'rev\|sha'
    rev = "0000000000000000000000000000000000000000";
    sha256 = "";
  };
  lispPackagesLite = (import hPkgsSrc {}).lispPackagesLite.override {
    inherit pkgs;
  };
};

with lispPackagesLite;

lispMultiDerivation {
  ... # same
}
```

This fetches a specific copy of my feature branch, loads only the `lispPackagesLite` module, and makes sure it integrates with your existing `<nixpkgs>` channel.

You would have to manually update both the revision and sha256 explicitly, when changes happen to this feature branch. If (God forbid) you want future proofing, please fork the repo--I could delete or garbage collect my copy.

### Setting custom Lisp

By default this package uses SBCL, but you can use any Lisp you want. Pass a supported Lisp derivation as the `lisp` argument to override.

Example:

```nix
{ pkgs ? import <nixpkgs> {} }:

with rec {
  lispPackagesLite = pkgs.lispPackagesLite.override {
    lisp = pkgs.ecl;
  };
};

...
```

The supported lisps are:

- SBCL (default)
- ECL

You can use any other lisp by passing a function which gets a filename, and returns a shell invocation that executes that file and then quits.

Example for clisp:

```nix
{ pkgs ? import <nixpkgs> {} }:

with rec {
  lispPackagesLite = pkgs.lispPackagesLite.override {
    lisp = f: "${pkgs.clisp}/bin/clisp ${f}";
  };
};

...
```

## Output: binary vs .fasl files

Is your program itself intended to be used as a dependency? Then you don’t need to do anything special: pre-compiled .fasls will be left next to each .lisp file, and you can include your derivation itself as a `lispDependencies` entry for another lisp derivation.

Do you want to output a single executable, instead? This is natively supported by ASDF, so you can leverage that. See [ASDF best practices][ASDF best practices] to configure ASDF. You can use a custom `installPhase` to only copy out the resulting binary to your `$out`, if you want to avoid the build noise. See the [`make-binary`](examples/make-binary) example in this project.

## Testing

Make sure your ASDF defines tests as per the standard ASDF conventions, see [ASDF best practices][ASDF best practices].

To enable a derivation’s checks, get its `enableCheck` property:

```
$ nix-build -A alexandria.enableCheck
```

This isn’t quite as elegant as `overrideAttrs (_: { doCheck = true; } )`, mostly because my Nix-fu isn’t at that level yet. WIP.

To test all packages, see [examples/test-all](examples/test-all).

## TODO

### Important

- Don't clobber existing `buildPhase` etc.
- Tool to fetch updates from all packages

### Nice-to-have

- Get all remaining packages’ tests passing.
- An example showing fasl-only building, no binary
- Complete the list of "standard mkDerivation args" (dontUnpack, ...)
- Don’t use `CL_SOURCE_REGISTRY` but use source map files?
- Don’t clobber existing `CL_SOURCE_REGISTRY`
- Document how to overwrite a package
- Using that: in the test-all, can we "inject" a check=true version of every package into the entire chain? Instead of building every package in test mode separately, but have each of them depend on non-checking packages? Should we, even?
- Fix binary building with ECL
- More lisps
- Test on Linux
- integrate with borg? First: decide if this belongs in nixpkgs at all.

### TODO: Fetching updates from source packages

The most important next step is a tool to assist in keeping the repositories up-to-date.

My plan:

Build the following automation:

1. Use Nix to build a file with all packages’ source locations (long story short: recursively descend into `.src` until it `hasAttr "gitRepoUrl"`).
2. Create a CL program that ingests that file, fetches every package, compares to current version checked, uses heuristics to determine upgradability (raw hash vs tag, master vs main, etc)
3. For all that need updating, automatically insert in packages.nix
4. Automatically nix-build just their source derivations and include the SHA256.

At this point you’d have an updated packages.nix and the user would need to:

1. Run [`test-all.nix`](examples/test-all) to check for regressions (todo: simplify that UX)
2. Fix any issues, e.g. changed dependencies (or worse if you’re unlucky).
3. Commit and PR

### Decisions to make about future direction

- Flakes? How much, if any support? All-in? Is it the future or a parallel universe?
- Should this be part of nixpkgs or stand-alone? I think nixpkgs: this is, itself, a collection of packages, and the point is to democratize Common Lisp’s package management. I have a feeling that’s the point of projects that do belong in nixpkgs, but I’m not certain--I also heard something about a departure from the nixpkgs channel in the brave new world of flakes, so TBD. I certainly don’t want this to end up under another BDFL’s auspice.

## Comparison to `lisp-modules` and `lisp-modules-new`

The crucial difference with both: No QuickLisp. This is an ideological difference rather than a material one, to an end user.

Concretely, the other two module systems are far more mature and ready for use. This project only supports two lisps (barely) and is in dire need of reliable testing on non-darwin platforms.

I have very little knowledge of `lisp-modules`, tbh I should have spent more time reading it, first, but I got drawn into building this thing and before I realised I had reimplemented it, it was too late. Sorry.

## Motivation

Common Lisp (ASDFv3) and the common Nix derivation idiom are fundamentally at odds: Nix packages are commonly one-repository-one-package (or to be precise "one derivation one package"). ASDFv3 on the other hand has no problems exporting multiple packages ("systems") from a single repository. If you map that directly to a single derivation, you either have to duplicate dependencies across multiple derivations, or build too much code when you don't need it.

Let's say you have a project that defines multiple systems. What do you build?

- Every possible derivation? Problem: you might not /want/ to build certain subsystems at all, particularly if both:
  1. the final project doesn’t need them, AND
  2. they can’t be built on your particular system
- Only one possible derivation? Problems:
  1. (small problem) "Which derivations does this package actually export vs which are just internal?" See e.g. `cl-async`, with `cl-async-ssl` (external) and `cl-async-util` (internal)
  2. (big problem) When one single repository defines multiple systems in one .asd file (again see `cl-async`), you could end up loading e.g. `cl-async-util` from the derivation that only pre-compiled `cl-async-base`, and ASDF will say, "Ok this directory DOES define cl-async-util, it just hasn’t pre-compiled it yet, so let me just do that right now!", try to write in the /nix/store, and fail. There is no sane way out of this post-facto. I call this "the cl-async issue".

The other lisp module implementations are smart about which package defines which systems. Based on QuickLisp, they export only those systems which are actually external. Unfortunately this isn't fool proof (see "https://github.com/NixOS/nixpkgs/pull/196818").

This implementation, on the other hand, does nothing smart at all. It treats all derivations and their source as a black box. You explicitly list which systems it exports, and that's it. It relies on ASDF to find those systems in those derivations.

The downside is a convoluted Nix implementation to figure out the actual dependency tree, particularly when multiple systems live in the same source derivation. To solve The Cl-async Issue, you need to ensure there is only ever exactly one copy of cl-async in the dependencies of the final project. This is a struggle in Nix, although it is possible. Notably this is done purely through the explicit dependencies as specified in the .nix hierarchy: no QuickLisp database nor .asd file introspection is done whatsoever.

## Why not QuickLisp?

QuickLisp and Nix solve the same problem: dependency management. The main benefit of QuickLisp for an end user is “just list your dependencies, and you're good to go”; Nix offers the same.

QuickLisp faces limitations that Nix doesn't need to worry about. Notably, it must be bootstrappable from pure Common Lisp without any dependencies. It has a low bus factor (basically just the one benevolent maintainer: Zach Beane). A discussion on this topic was held in 2016 on [Hacker News](https://news.ycombinator.com/item?id=13097333), and the comments ring just as true in 2022. Notably, someone laments the lack of alternative. I believe Nix can fill that gap.

The other lisp modules leverage QuickLisp which helps bootstrap the list of packages and “known good versions”, and updates. In this package, there are no special cases: every package must be included, managed and updated manually.

But perhaps the most important reason to omit QL is “because there are already two other modules that rely on QL and I wanted to try it without.”

## Links

- [ASDF best practices][ASDF best practices]
- [ASDF 3, or Why Lisp is Now an Acceptable Scripting Language (extended version)](http://fare.tunes.org/files/asdf3/asdf3-2014.html): Extremely detailed design document by the author of ASDFv3 with tons of lisp wisdom, and general programming wisdom. Recommended reading.
- [lisp-modules](../lisp-modules): The original Common Lisp module in nixpkgs. Relies on QuickLisp.
- [lisp-modules-new](../lisp-modules-new): A fresh reimplementation of Common-Lisp-in-Nix. Also relies on QuickLisp.
- [what is `makeScope`](https://old.reddit.com/r/NixOS/comments/z47sky/introducing_lisppackageslite_common_lisp_in_pure/ixr0snv/): Reddit user jonringer117 explains `makeScope`.

[ASDF best practices]: https://github.com/fare/asdf/blob/master/doc/best_practices.md

## License

Copyright © 2022  Hraban Luyat

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
