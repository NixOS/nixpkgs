{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tweeny";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mobius3";
    repo = "tweeny";
    rev = "v${version}";
    sha256 = "0qvby57g9a2m4afd1mgard3k7nm4ynbvali7nzm1qn3ygdmqid7n";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A modern C++ tweening library";
    license = licenses.mit;
    homepage = "http://mobius3.github.io/tweeny";
    maintainers = [ maintainers.doronbehar ];
    platforms = with platforms; darwin ++ linux;
  };
}
