{ lib, fetchurl, buildDunePackage, xmlm }:

buildDunePackage rec {
  pname = "ezxmlm";
  version = "1.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ezxmlm/releases/download/v${version}/ezxmlm-v${version}.tbz";
    sha256 = "123dn4h993mlng9gzf4nc6mw75ja7ndcxkbkwfs48j5jk1z05j6d";
  };

  propagatedBuildInputs = [ xmlm ];

  meta = with lib; {
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
    maintainers = [ maintainers.carlosdagos ];
    homepage = "https://github.com/mirage/ezxmlm/";
    license = licenses.isc;
  };
}
