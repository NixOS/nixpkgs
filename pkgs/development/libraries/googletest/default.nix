{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "googletest";
  version = "1.8.1";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "release-" + version;
    sha256 = "0270msj6n7mggh4xqqjp54kswbl7mkcc8px1p5dqdpmw5ngh9fzk";
  };

  buildInputs = [ cmake ];

  postInstall = ''
    mkdir -p $out/share/${name}
    for f in $(ls -I build ..);do
      mv ../$f $out/share/${name}
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/google/googletest;
    description = "C++ testing and mocking framework.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
  };
}
