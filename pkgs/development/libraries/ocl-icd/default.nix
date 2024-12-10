{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  opencl-headers,
  addOpenGLRunpath,
  autoreconfHook,
  windows,
}:

stdenv.mkDerivation rec {
  pname = "ocl-icd";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    rev = "v${version}";
    sha256 = "sha256-nx9Zz5DpS29g1HRIwPAQi6i+d7Blxd53WQ7Sb1a3FHg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    ruby
  ];

  buildInputs = [ opencl-headers ] ++ lib.optionals stdenv.hostPlatform.isWindows [ windows.dlfcn ];

  configureFlags = [
    "--enable-custom-vendordir=/run/opengl-driver/etc/OpenCL/vendors"
  ];

  # fixes: can't build x86_64-w64-mingw32 shared library unless -no-undefined is specified
  makeFlags = lib.optionals stdenv.hostPlatform.isWindows [ "LDFLAGS=-no-undefined" ];

  meta = with lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    mainProgram = "cllayerinfo";
    homepage = "https://github.com/OCL-dev/ocl-icd";
    license = licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ r-burns ];
  };
}
