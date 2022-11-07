# Benefits of using Nix for Common Lisp projects

Nix solves the package management problem well. Re-using that
infrastructure brings a number of benefits to the Common Lisp world.


## Bundled native dependencies

Bundle native dependencies, such as `.so` or `.jar` files,
together with the ASDF systems.

They're all just Nix packages, so combining them is first-class.

With Clasp/clbind there is also an unexplored opportunity to bundle C++
libraries.

### Example

Let's build `cl-liballegro` for SBCL.

Make sure you are in the root of the `nix-cl` repository, then run:
```shell
nix-build -E 'with import ./. {}; sbclPackages.cl-liballegro'
```

You'll see some compilation logs, then in `ls result/` you will see the
compiled FASLs of `cl-liballegro`.

Let's start an `sbclWithPackages`: an SBCL with `cl-liballegro` available to `asdf:load-system`.
```shell
nix-build -E 'with import ./. {}; sbclWithPackages (p: [ p.cl-liballegro ])'
rlwrap result/bin/sbcl
```

See that `sbclPackages.cl-liballegro` is not built a second time when
building the `sbclWithPackages`. Instead, it's cached from the first
invocation.

Now inside of SBCL, we can open a window using Allegro:
```lisp
(require :asdf)
(asdf:load-system :cl-liballegro)
(al:init)
(al:create-display 800 600)
(al:destroy-display *)
```

See that no compilation takes place. Instead, the FASLs pre-compiled in
our first step are loaded, which is very fast.

You **didn't** have to:

- Install SBCL
- Install GCC (required to build `cffi-libffi`)
- Install the `libffi.so` library (required to build `cffi-libffi`)
- Download the Allegro libraries (`liballegro.so` etc.)

All you needed was to have Nix installed, and have the `nix-cl` code.

You can try for yourself with other implementations: CCL, ECL, ABCL.

ABCL will be interesting, because it needs the JNA Java library in order
to use `liballegro.so`. Of course you don't need to do anything, Nix
will handle this automatically.

## Parallelized builds

Parallelized builds are given to you for free, inferred from the
dependencies between different ASDF systems.

This happens on the ASDF system level (`asdf:compile-system`). It won't
magically make building of a single system parallel (`cl:compile-file`).

### Example

Just to see that it works, you can launch a build of something big, like `dexador`:
```
nix-build -E 'with import ./. {}; sbclPackages.dexador'
```

In another terminal, open `htop` and find the `sbcl` process. You can
see that it spreads the work of building `dexador`'s ASDF dependencies
to as many CPUs as you have in your machine.

## Per-project environments

Nix has the feature of isolated development environments called a
`nix-shell`. 

This means you can have two projects such as these coexist on one
machine, without conflict:

- A project using `sbcl 1.7.0` built with `glibc 2.21`, and
`alexandria 0.9` and `cl-liballegro` using `allegro 5.1`

- A project using `sbcl 2.2.3` built with `glibc 2.35`, and
`alexandria 1.2` and `cl-liballegro` using `allegro 5.2`.
 
When you're done, you can clean up with
`nix-collect-garbage`. Everything will be removed from your disk,
leaving you back where you started.

### Example

To use `nix-shell` you write down what you want to be inside your
environment in a `shell.nix` file:

```nix
let

  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/21.11.tar.gz";
    sha256 = "162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
  }) {};

  nix-cl = import ./. { inherit pkgs; };

  sbcl = nix-cl.sbclWithPackages (ps: [
    ps.cl-liballegro
  ]);

  ccl = nix-cl.cclWithPackages (ps: [
    ps.hunchentoot
  ]);

in pkgs.mkShell {

  buildInputs = [
    sbcl
    ccl
  ];

}
```

Then execute `nix-shell` in the directory containing the `shell.nix` file.

You can verify that `cl-liballegro` is loadable from `sbcl`, but not
from `ccl`. Vice versa for `hunchentoot`. This is because their ASDF
paths are logically isolated from each other. 

They will still share common paths where it makes sense. If they're
both using *identical* versions of a native library such as `openssl`,
then it will be shared. If it's a different commit of it, they will
use separate store paths. This also applies to Lisp source
tarballs. This saves some space by preventing unnecessary duplicates.

This can work because `/nix/store` is read only. Therefore `sbcl` and
`ccl` can't mess with each others dependencies.

## Shippable FASLs

Because you have full control of the Lisp implementation, you can ship
FASLs. With traditional methods that's not possible, because you don't
know the exact version of Lisp the user is running, and they are not
necessarily binary compatible.

This means you don't need to have `gcc` installed to load
`cffi-libffi` anymore. The CI server can build `cfii-libffi` once, and
everyone can enjoy the FASLs directly, without having to spend time
compiling.
  
Likewise you don't need to wait for `ironclad` to compile anymore
(especially on ECL, ABCL where it can take long).

You've already seen this, when we loaded `cl-liballegro` in the first
example. Then, the `/nix/store/` path was created locally. Later on,
when we create a binary cache, you will see how it will be downloaded
from a server instead, in a process called "substitution".
  
## Docker images

Generate optimized Docker images containing a Lisp and chosen ASDF
libraries.

Another freebie. Simply run: 

`nix bundle --bundler github:NixOS/bundlers#toDockerImage` 

on the derivation created by `sbclWithPackages`.

### Example

Let's do something fun, a web server with `hunchentoot`, `sqlite` and
`jzon`. This will demonstrate again the bundling of native libraries:
OpenSSL and SQLite. Also we'll show the ability to transparently use a
library that's not in Quicklisp - `jzon`.

We need a Lisp with the libraries. Let's put it in a Docker container:
```
nix bundle --bundler github:NixOS/bundlers#toDockerImage --impure --expr \
  'with import ./. {}; sbclWithPackages (p: [ p.hunchentoot p.sqlite p.jzon ])'
```

This creates the `sbcl-with-packages.tar.gz` file in the current directory.

Load it into docker:
```shell
docker load < sbcl-with-packages.tar.gz
```

And demonstrate the usage of hunchentoot and SQLite inside the container:

Run it first:
```shell
docker run -p 4242:4242 -ti sbcl-with-packages sbcl
```

Start the hunchentoot server inside the container:
```
(require :asdf)
(asdf:load-system :hunchentoot)
(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))
```

At this point you can open your local browser on `http://localhost:4242`
and see hunchentoot running.

But let's add SQLite to the mix:

```
(require :sqlite)

(defparameter *db* (sqlite:connect ":memory:"))

(sqlite:execute-non-query *db* 
  "create table movie (name, director)")

(sqlite:execute-non-query *db* 
  "insert into movie values ('Matrix', 'Lana and Lilly Wachowski')")

(asdf:load-system :com.inuoe.jzon)
(import 'com.inuoe.jzon:stringify)

(hunchentoot:define-easy-handler (get-movie :uri "/movie") (name)
  (setf (hunchentoot:content-type*) "application/json")
  (let ((movie (sqlite:execute-to-list *db* 
                 "select * from movie where name=?" name)))
    (if movie
        (stringify (pairlis '(name director) (first movie)))
        "No such movie.")))
```

Now you can go to the URL `http://localhost:4242/movie?name=Matrix` in
the browser and see that it works.

This is a powerful tool, because you can declaratively create any
combination of Lisp implementation/ASDF systems as a Docker container.

As an exercise you could try to:

- Build the same image twice - it will not be rebuilt, but cached from
  the previous run.

- Change the order of libraries in `[ p.hunchentoot p.sqlite p.jzon ]`.
  This also does not cause a rebuild, because it's a fully declarative
  specification of the image, unlike a Dockerfile which is more like a
  script.
  
- Poke around in the container with `uiop:directory-files`. You will
  see that it contains precisely what it needs: SBCL, glibc, OpenSSL,
  SQLite and the ASDF system FASLs. There's not even things like
  coreutils (`ls`/`cp`). Therefore it can be a lot smaller than
  traditional images.

## Decentralized package repositories

With Nix you can benefit from having your own private/internal binary
cache of ASDF systems, pre-compiled FASLs, Lisp implementations. This
could be interesting if you want to be independent from central
repositories.

You can also make your binary cache public and share the artifacts
with the world.

Notes:

- You could have your CI server do this instead.
- You could also use cachix.

(add example of setting up a binary cache and downloading on another machine)

## Dependency graph PDFs

Looking at Lisp dependency graphs cold be interesting as a thing to do
when you're bored. It has the side benefit of visualizing how much third
party code is in your product.

### Example 

As an example let's generate a graph of `dexador`'s dependencies:

```shell
nix-store -q --graph $(nix-build -E 'with import ./. {}; sbclPackages.dexador') | dot -x -T pdf > dexador.pdf
```

# Drawbacks of using Nix for Lisp

## No Windows support

Windows support. There's almost none currently.

There is the possibility of building with Wine. There were some
experiments, it works, but is currently very hacky.

(add link to experimental branch)

## Incomplete support for slashy systems

Because ASDF slashy systems exist in the same `.asd` file as their main
system, when you create a `lispWithPackages` or write a package that
depends one one, it can cause unloadable systems. The reason is that
other packages can still depend on the parent system, which results in
two `.asd` files with the same name in the `CL_SOURCE_REGISTRY`. This
combined with the fact that `/nix/store` is read-only, can sometimes
result in an error where ASDF tries to compile FASLs there.

The previous attempt to fix this worked correctly, but was inefficient
causing slow builds.

Maybe deferring the evaluation of dependent packages until build time
could solve this. Join the discussion if you want to contribute an idea.

Or, omit slashy systems from the package sets, and instead allow them
only via modified `systems` via `overrideLispAttrs`. The overrides
should then propagate through the package set in a similar way to
nixpkgs overlays.

(add link to removed solution)

## Nix learning curve

Nix suite of tools has historically had minimal documentation. Nix
being a custom language means there is a lack of tooling as well (Guix
solves this by reusing Guile tooling).

So it could be too costly to use Nix for some people, even considering
the aforementioned benefits.

(add link to Nix documentation)

## Not suitable for fine-grained dependencies

Nix is suited well for coarse-grained dependencies, such as packages
or whole ASDF systems.

But it can't handle things like dependencies between individual files
in a system. There ASDF itself still is the most prominent tool.
