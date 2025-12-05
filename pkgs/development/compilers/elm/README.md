# To update Elm:

Modify revision in ./update.sh and run it

# Notes about the build process:

The elm binary embeds a piece of pre-compiled elm code, used by 'elm
reactor'. This means that the build process for 'elm' effectively
executes 'elm make'. that in turn expects to retrieve the elm
dependencies of that code (elm/core, etc.) from
package.elm-lang.org, as well as a cached bit of metadata
(versions.dat).

The makeDotElm function lets us retrieve these dependencies in the
standard nix way. We have to copy them in (rather than symlink) and
make them writable because the elm compiler writes other .dat files
alongside the source code. versions.dat was produced during an
impure build of this same code; the build complains that it can't
update this cache, but continues past that warning.

Finally, we set ELM_HOME to point to these pre-fetched artifacts so
that the default of ~/.elm isn't used.

More: https://blog.hercules-ci.com/elm/2019/01/03/elm2nix-0.1/
