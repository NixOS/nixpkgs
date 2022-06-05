{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libdmtx";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "dmtx";
    repo = "libdmtx";
    rev = "v${version}";
    sha256 = "0wk3fkxzf9ip75v8ia54v6ywx72ajp5s6777j4ay8barpbv869rj";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = {
    description = "An open source software for reading and writing Data Matrix barcodes";
    homepage = "https://github.com/dmtx/libdmtx";
    changelog = "https://github.com/dmtx/libdmtx/blob/v${version}/ChangeLog";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.bsd2;
  };
}
