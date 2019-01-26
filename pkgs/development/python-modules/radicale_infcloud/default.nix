{ stdenv, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "radicale_infcloud";
  version = "2017-07-27";

  src = fetchFromGitHub {
    owner = "Unrud";
    repo = "RadicaleInfCloud";
    rev = "972757bf4c6be8b966ee063e3741ced29ba8169f";
    sha256 = "1c9ql9nv8kwi791akwzd19dcqzd916i7yxzbnrismzw4f5bhgzsk";
  };

  doCheck = false; # Tries to import radicale, circular dependency

  meta = with stdenv.lib; {
    homepage = https://github.com/Unrud/RadicaleInfCloud/;
    description = "Integrate InfCloud into Radicale's web interface";
    license = with licenses; [ agpl3 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ aneeshusa ];
  };
}
