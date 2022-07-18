{ lib
, stdenv
, buildPythonPackage
, pythonOlder
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
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "clickgen";
    rev = "v${version}";
    sha256 = "sha256-01c8SVy+J004dq5KCUe62w7i/xUTxTfl/IpvUtGQgw0=";
  };

  buildInputs = [ libXcursor libX11 libpng ];

  propagatedBuildInputs = [ pillow ];

  checkInputs = [ pytestCheckHook ];

  postBuild = ''
    # Needs to build xcursorgen.so
    cd src/xcursorgen
    make
    cd ../..
  '';

  postInstall = ''
    install -m644 src/xcursorgen/xcursorgen.so $out/${python.sitePackages}/clickgen/xcursorgen.so
    # Copying scripts directory needed by clickgen script at $out/bin/
    cp -R src/clickgen/scripts $out/${python.sitePackages}/clickgen/scripts
  '';

  pythonImportsCheck = [ "clickgen" ];

  meta = with lib; {
    homepage = "https://github.com/ful1e5/clickgen";
    description = "The hassle-free cursor building toolbox";
    longDescription = ''
      clickgen is API for building X11 and Windows Cursors from
      .png files. clickgen is using anicursorgen and xcursorgen under the hood.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AdsonCicilioti ];
    # fails with:
    # ld: unknown option: -zdefs
    broken = stdenv.isDarwin;
  };
}
