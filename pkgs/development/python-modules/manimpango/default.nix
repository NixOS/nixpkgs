{ stdenv, lib, buildPythonPackage, fetchFromGitHub, python, pkg-config, pango, cython, AppKit, pytestCheckHook }:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = pname;
    rev = "v${version}";
    sha256 = "ldZfvv5kloQ0uj0agxOP8cRh+Ix8f9Z0PT+pnhWYjiQ=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "--cov --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pango ] ++ lib.optionals stdenv.isDarwin [ AppKit ];
  propagatedBuildInputs = [
    cython
  ];

  preBuild = ''
    ${python.interpreter} setup.py build_ext --inplace
  '';

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "manimpango" ];

  meta = with lib; {
    homepage = "https://github.com/ManimCommunity/ManimPango";
    license = licenses.gpl3Plus;
    description = "Binding for Pango";
    maintainers = [ maintainers.angustrau ];
  };
}
