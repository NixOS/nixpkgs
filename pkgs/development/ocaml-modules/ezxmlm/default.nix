{ stdenv, fetchFromGitHub, buildDunePackage, xmlm }:

buildDunePackage rec {
  pname = "ezxmlm";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "avsm";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dgr61f0hymywikn67inq908x5adrzl3fjx3v14l9k46x7kkacl9";
  };

  propagatedBuildInputs = [ xmlm ];

  meta = with stdenv.lib; {
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
    inherit (src.meta) homepage;
    license = licenses.isc;
  };
}
