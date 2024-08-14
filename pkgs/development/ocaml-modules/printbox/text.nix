{ buildDunePackage, lib, ocaml, printbox, uucp, uutf, mdx }:

buildDunePackage {
  pname = "printbox-text";
  inherit (printbox) src version;

  propagatedBuildInputs = [ printbox uucp uutf ];

  doCheck = printbox.doCheck && lib.versionOlder ocaml.version "5.0";
  nativeCheckInputs = [ mdx.bin ];

  meta = printbox.meta // {
    description = "Text renderer for printbox, using unicode edges";
  };
}
