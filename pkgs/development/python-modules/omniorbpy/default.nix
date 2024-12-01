{
  lib,
  buildPythonPackage,
  fetchurl,
  omniorb,
  pkg-config,
  python,
}:

buildPythonPackage rec {
  pname = "omniorbpy";
  version = "4.3.2";
  pyproject = false;

  src = fetchurl {
    url = "http://downloads.sourceforge.net/omniorb/omniORBpy-${version}.tar.bz2";
    hash = "sha256-y1cX1BKhAbr0MPWYysfWkjGITa5DctjirfPd7rxffrs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ omniorb ];

  configureFlags = [
    "--with-omniorb=${omniorb}"
    "PYTHON_PREFIX=$out"
    "PYTHON=${python.interpreter}"
  ];

  # Transform omniidl_be into a PEP420 namespace
  postInstall = ''
    rm $out/${python.sitePackages}/omniidl_be/__init__.py
    rm $out/${python.sitePackages}/omniidl_be/__pycache__/__init__.*.pyc
  '';

  # Ensure both python & cxx backends are available
  pythonImportsCheck = [
    "omniidl_be.cxx"
    "omniidl_be.python"
    "omniORB"
  ];

  meta = with lib; {
    description = "Python backend for omniorb";
    homepage = "http://omniorb.sourceforge.net";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
}
