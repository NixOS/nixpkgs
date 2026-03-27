{
  lib,
  fetchurl,
  buildDunePackage,
  xmlm,
}:

buildDunePackage (finalAttrs: {
  pname = "ezxmlm";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/ezxmlm/releases/download/v${finalAttrs.version}/ezxmlm-v${finalAttrs.version}.tbz";
    hash = "sha256-zcgCfpiySES043PNzpo9SpbDq2GWuP/Ss7SOlCCxbYg=";
  };

  propagatedBuildInputs = [ xmlm ];

  meta = {
    description = "Combinators to use with xmlm for parsing and selection";
    longDescription = ''
      An "easy" interface on top of the xmlm library. This version provides
      more convenient (but far less flexible) input and output functions
      that go to and from [string] values. This avoids the need to write signal
      code, which is useful for quick scripts that manipulate XML.

      More advanced users should go straight to the Xmlm library and use it
      directly, rather than be saddled with the Ezxmlm interface. Since the
      types in this library are more specific than Xmlm, it should interoperate
      just fine with it if you decide to switch over.
    '';
    maintainers = [ lib.maintainers.carlosdagos ];
    homepage = "https://github.com/mirage/ezxmlm/";
    license = lib.licenses.isc;
  };
})
