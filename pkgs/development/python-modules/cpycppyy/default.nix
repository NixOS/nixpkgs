{
  lib,
  fetchFromGitHub,
  cppyy-cling,
  cppyy-backend,
  cmake,
  buildPythonPackage,
  setuptools,
  python3,
  wheel,
  pip,
  stdenv,
}:

buildPythonPackage rec {
  pname = "CPyCppyy";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "wlav";
    repo = pname;
    rev = "8bd9d9e10d658a33294a4ba9b2251bf1f9223469";
    hash = "sha256-IEwdJSXG6diz7j2N7WQys5na7+xj1CYu7J3FCkW9/AQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pip
    cmake
    cppyy-cling
    cppyy-backend
  ];

  propagatedBuildInputs = [
    cppyy-cling
    cppyy-backend
  ];

  patches = [
    ./cpycppy-setup.patch
  ];

  dontUseCmakeConfigure = true;

  configurePhase = ''
    sed -i "s|%cflags_placeholder%|return '${lib.optionalString stdenv.hostPlatform.isLinux "-pthread"} -std=c++2a'|" setup.py
  '';

  pipInstallFlags = [
    "--no-use-pep517"
    "--no-deps"
  ];

  postInstall = ''
    cmake ../${pname}-${version}
    make
    cp libcppyy${stdenv.hostPlatform.extensions.sharedLibrary} $out/${python3.sitePackages}/
  '';

  meta = with lib; {
    homepage = "https://github.com/wlav/CPyCppyy";
    description = "CPyCppyy: Python-C++ bindings interface based on Cling/LLVM";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ kittywitch ];
  };
}
