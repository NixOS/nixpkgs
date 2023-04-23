{ buildDunePackage, printbox, uucp, uutf, mdx }:

buildDunePackage {
  pname = "printbox-text";
  inherit (printbox) src version useDune2 doCheck;

  propagatedBuildInputs = [ printbox uucp uutf ];

  nativeCheckInputs = [ mdx.bin ];

  meta = printbox.meta // {
    description = "Text renderer for printbox, using unicode edges";
  };
}
