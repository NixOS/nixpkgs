## Importing package definitions from Quicklisp

This page documents how to import packages from Quicklisp.

## Nix dumper

Run:

```
$ nix-shell
$ sbcl --script ql-import.lisp
```

This command runs a program that dumps a `imported.nix` file
containing Nix expressions for all packages in Quicklisp. They will be
automatically picked up by the `lispPackagesFor` and
`lispWithPackages` API functions.

It also creates a 'packages.sqlite' file. It's used during the
generation of the 'imported.nix' file and can be safely removed. It
contains the full information of Quicklisp packages, so you can use it
to query the dependency graphs using SQL, if you're interested.

## Tarball hashes

The Nix dumper program will re-use hashes from "imported.nix" if it
detects that it's being run for the first time. This saves a lot of
bandwidth by not having to download each tarball again.

But when upgrading the Quicklisp release URL, this can take a while
because it needs to fetch the source code of each new system to
compute its SHA256 hash. This is because Quicklisp only provides a
SHA1 , and Nix's `builtins.fetchTarball` requires a SHA256.

Later on, the hashes are cached in `packages.sqlite`, and are reused
in subsequent invocations. Therefore you might want to keep the
'packages.sqlite' file around if you'd like to keep hashes of
historical Quicklisp tarballs, for example for archival purposes.

## Choosing a Quicklisp release

Quicklisp release url's are currently hard-coded and can be changed
directly in the source code. See the `import` directory.

## Native and Java libraries

At the moment, native and Java libraries need to be added manually to
imported systems in `ql.nix` on an as-needed basis.

## Dependencies from packages.nix

Also worth noting is that systems imported from Quicklisp will prefer
packages from `packages.nix` as dependencies, so that custom versions
can be provided or broken versions replaced.
