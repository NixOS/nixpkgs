{
  lib,
  fetchFromGitHub,
  cppyy-cling,
  cppyy-backend,
  cmake,
  buildPythonPackage,
  setuptools,
  wheel,
  pip,
  python,
  stdenv,
}:

buildPythonPackage rec {
  pname = "CPyCppyy";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wlav";
    repo = pname;
    # Uncomment and replace rev & hash lines when a new release occurs within CPyCppyy.
    #tag = "CPyCppyy-${version}";
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

  configurePhase = ''
    runHook preConfigure
    sed -i "s|%cflags_placeholder%|return '${lib.optionalString stdenv.hostPlatform.isLinux "-pthread"} -std=c++2a'|" setup.py
    runHook postConfigure
  '';

  pipInstallFlags = [
    "--no-use-pep517"
    "--no-deps"
  ];

  postBuild = ''
    cmake ./
    make
  '';

  postInstall = ''
    cp libcppyy.so $out/${python.sitePackages}/
  '';

  meta = {
    homepage = "https://github.com/wlav/CPyCppyy";
    description = "CPyCppyy: Python-C++ bindings interface based on Cling/LLVM";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ kittywitch ];
  };
}
