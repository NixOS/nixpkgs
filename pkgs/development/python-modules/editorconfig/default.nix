{ stdenv
, buildPythonPackage
, fetchgit
, cmake
}:

buildPythonPackage rec {
  pname = "editorconfig";
  version = "0.12.2";

  # fetchgit used to ensure test submodule is available
  src = fetchgit {
    url = "https://github.com/editorconfig/editorconfig-core-py";
    rev = "596da5e06ebee05bdbdc6224203c79c4d3c6486a"; # Not tagged
    sha256 = "05cbp971b0zix7kfxkk7ndxb4ax1l21frwc00d4g78mk4sdz6dig";
  };

  nativeBuildInputs = [ cmake ];

  dontUseCmakeConfigure = true;

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
