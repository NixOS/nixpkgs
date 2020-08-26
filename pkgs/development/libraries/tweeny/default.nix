{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tweeny";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "mobius3";
    repo = "tweeny";
    rev = "v${version}";
    sha256 = "0zk7p21i54hfz0l50617i3gxhxh0n9yy86n2fxg8m26cvf4yhsj7";
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
