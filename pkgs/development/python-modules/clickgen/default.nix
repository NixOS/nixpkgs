{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, libX11
, libXcursor
, libpng
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clickgen";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "clickgen";
    rev = "v${version}";
    sha256 = "108f3sbramd3hhs4d84s3i3lbwllfrkvjakjq4gdmbw6xpilvm0l";
  };

  buildInputs = [ libXcursor libX11 libpng ];

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "clickgen" ];

  postInstall = ''
    install -m644 clickgen/xcursorgen.so $out/${python.sitePackages}/clickgen/xcursorgen.so
  '';

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/ful1e5/clickgen";
    description = "The hassle-free cursor building toolbox";
    longDescription = ''
      clickgen is API for building X11 and Windows Cursors from
      .png files. clickgen is using anicursorgen and xcursorgen under the hood.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AdsonCicilioti ];
  };
}
