<<<<<<< HEAD
{ buildDunePackage, lib, ocaml, printbox, uucp, uutf, mdx }:

buildDunePackage {
  pname = "printbox-text";
  inherit (printbox) src version;

  propagatedBuildInputs = [ printbox uucp uutf ];

  doCheck = printbox.doCheck && lib.versionOlder ocaml.version "5.0";
=======
{ buildDunePackage, printbox, uucp, uutf, mdx }:

buildDunePackage {
  pname = "printbox-text";
  inherit (printbox) src version useDune2 doCheck;

  propagatedBuildInputs = [ printbox uucp uutf ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [ mdx.bin ];

  meta = printbox.meta // {
    description = "Text renderer for printbox, using unicode edges";
  };
}
