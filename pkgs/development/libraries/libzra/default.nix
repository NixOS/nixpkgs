{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libzra";
  version = "unstable-2020-08-10";

  src = fetchFromGitHub {
    owner = "zraorg";
    repo = "zra";
    rev = "e678980ae7e79efd716b4a6610fe9f148425fd6b";
    sha256 = "132xyzhadahm01nas8gycjza5hs839fnpsh73im2a7wwfdw76z4h";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/zraorg/ZRA";
    description = "Library for ZStandard random access";
    platforms = platforms.all;
    maintainers = [ maintainers.ivar ];
    license = licenses.bsd3;
  };
}
