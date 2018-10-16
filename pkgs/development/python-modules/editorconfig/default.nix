{ stdenv
, buildPythonPackage
, fetchgit
, cmake
}:

buildPythonPackage rec {
  pname = "EditorConfig";
  version = "0.12.1";

  # fetchgit used to ensure test submodule is available
  src = fetchgit {
    url = "https://github.com/editorconfig/editorconfig-core-py";
    rev = "refs/tags/v${version}";
    sha256 = "0svk7id7ncygj2rnxhm7602xizljyidk4xgrl6i0xgq3829cz4bl";
  };

  buildInputs = [ cmake ];
  checkPhase = ''
    cmake .
    # utf_8_char fails with python3
    ctest -E "utf_8_char" .
  '';

  meta = with stdenv.lib; {
    homepage = https://editorconfig.org;
    description = "EditorConfig File Locator and Interpreter for Python";
    license = licenses.psfl;
  };

}
