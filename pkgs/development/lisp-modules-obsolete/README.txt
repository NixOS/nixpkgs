Want to add a package?  There are 3 simple steps!
1. Add the needed system names to quicklisp-to-nix-systems.txt.
2. cd <path to quicklisp-to-nix-systems.txt> ; nix-shell --pure --run 'quicklisp-to-nix .'
  You might want to specify also the --cacheSystemInfoDir and --cacheFaslDir
  parameters to preserve some data between runs. For example, it is very
  useful when you add new packages with native dependencies and fail to
  specify the native dependencies correctly the first time.
  (Might be nice to ensure the cache directories exist)
3. Add native libraries and whatever else is needed to quicklisp-to-nix-overrides.nix.
   If libraries are needed during package analysis then add them to shell.nix, too.
4. Sometimes there are problems with loading implementation-provided systems.
  In this case you might need to add more systems in the implementation's (so
  SBCL's) entry into *implementation-systems* in quicklisp-to-nix/system-info.lisp

To update to a more recent quicklisp dist modify
lispPackages.quicklisp to have a more recent distinfo.

quicklisp-to-nix-system-info is responsible for installing a quicklisp
package into an isolated environment and figuring out which packages
are required by that system.  It also extracts other information that
is readily available once the system is loaded.  The information
produced by this program is fed into quicklisp-to-nix.  You usually
don't need to run this program unless you're trying to understand why
quicklisp-to-nix failed to handle a system.  The technique used by
quicklisp-to-nix-system-info is described in its source.

quicklisp-to-nix is responsible for reading
quicklisp-to-nix-systems.txt, running quicklisp-to-nix-system-info,
and generating the nix packages associated with the closure of
quicklisp systems.
