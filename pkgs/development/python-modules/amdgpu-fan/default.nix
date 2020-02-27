{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, pyyaml, setuptools }:

buildPythonPackage rec {
  pname = "amdgpu-fan";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "chestm007";
    repo = pname;
    rev = version;
    sha512 = "33bqbg6hp4y0pa5nc4jwk4dfsip48p14kdd3jvbww5bf4wn4z3acqzzcrszrx1yc5gmn3744hg49a1fv67mqncn3nl9kp6hmlnwv0lb";
  };

  doCheck = false;

  propagatedBuildInputs = [ numpy pyyaml ];
  buildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py --replace 'PROJECTVERSION' '${version}'
  '';

  meta = with stdenv.lib; {
    description = "Python controller for amdgpu fan";
    homepage = "https://github.com/chestm007/amdgpu-fan";
    maintainers = with maintainers; [ grburst ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
