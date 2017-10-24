{ stdenv, fetchFromGitHub, gtk_doc, libtool, automake, autoconf, pkgconfig, gtk3 }:

let
  pname = "statusnotifier";
  version = "1.0.0";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jjk-jacky";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "12ybfnk3f2aq01fibx58nc6cn7zwscs4d9b01wlnzfyfmr0a207a";
  };

  nativeBuildInputs = [ gtk_doc libtool automake autoconf pkgconfig ];
  buildInputs = [ gtk3 ];

  preConfigure = ''
    ./autogen.sh
  '';

  preBuild = ''
    patchShebangs src
  '';

  configureFlags = [
    "--enable-example"
  ];
}
