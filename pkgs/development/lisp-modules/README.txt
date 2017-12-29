Prerequisite: have Quicklisp installed somehow.

Add to LD_LIBRARY_PATH all the things listed in quicklisp-to-nix-overrides.nix
for library propagatedBuildInputs (a lot of these are done via addNativeLibs).

Current list is:
openssl fuse libuv mariadb libfixposix libev sqlite

Add the needed system names to quicklisp-to-nix-systems.txt and load
quicklisp-to-nix/ql-to-nix.lisp and call
(ql-to-nix "/path/to/nixpkgs/pkgs/development/lisp-modules/") which is often
just (ql-to-nix ".")

Add native libraries and whatever else is needed to overrides.

The lispPackages set is supposed to be buildable in its entirety.
