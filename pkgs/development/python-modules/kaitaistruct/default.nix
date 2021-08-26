{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, lz4
}:

let
  kaitai_compress = fetchFromGitHub {
    owner = "kaitai-io";
    repo = "kaitai_compress";
    rev = "434fb42220ff58778bb9fbadb6152cad7e4f5dd0";
    sha256 = "zVnkVl3amUDOB+pnw5SkMGSrVL/dTQ82E8IWfJvKC4Q=";
  };
in
buildPythonPackage rec {
  pname = "kaitaistruct";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d5845817ec8a4d5504379cc11bd570b038850ee49c4580bc0998c8fb1d327ad";
  };

  preBuild = ''
    ln -s ${kaitai_compress}/python/kaitai kaitai
    sed '28ipackages = kaitai/compress' -i setup.cfg
  '';

  propagatedBuildInputs = [
    lz4
  ];

  # no tests
  dontCheck = true;

  pythonImportsCheck = [
    "kaitaistruct"
    "kaitai.compress"
  ];

  meta = with lib; {
    description = "Kaitai Struct: runtime library for Python";
    homepage = "https://github.com/kaitai-io/kaitai_struct_python_runtime";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
