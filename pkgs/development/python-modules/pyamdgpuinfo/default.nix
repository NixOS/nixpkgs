{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  setuptools,
  wheel,

  # buildInputs
  libdrm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyamdgpuinfo";
  version = "2.1.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-44mYHwC/Qv3kEjOViiHGKIhTpGx9/nsGKyq+BUz7HXs=";
  };

  # The Cython extension is compiled against libdrm's amdgpu headers, which upstream looks for at the
  # Debian/Arch location.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'include_dirs=["/usr/include/libdrm"]' 'include_dirs=["${libdrm.dev}/include/libdrm"]'
  '';

  build-system = [
    cython
    setuptools
    wheel
  ];

  buildInputs = [ libdrm ];

  # Upstream ships no test suite, and reading GPU stats needs an AMD card anyway.
  doCheck = false;

  pythonImportsCheck = [ "pyamdgpuinfo" ];

  meta = {
    description = "AMD GPU stats";
    homepage = "https://github.com/mark9064/pyamdgpuinfo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ giggio ];
    platforms = lib.platforms.linux;
  };
})
