{ stdenv, lib, buildPythonPackage, fetchFromGitHub
, cython
, libxml2
, libxslt
, zlib
, xcodebuild
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.9.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/lxml-${version}";
    hash = "sha256-qS20wb83eFapiPZe25BViHpYkjgvnCIZpiYkPNIPHZg=";
  };

  patches = [
    # fix compile error with libxml 2.12
    # backport of: https://github.com/lxml/lxml/commit/b0861bea17769584a85f57eb00235ce0ca9811af
    ./libxml-2.12.patch
  ];

  # setuptoolsBuildPhase needs dependencies to be passed through nativeBuildInputs
  nativeBuildInputs = [ libxml2.dev libxslt.dev cython ] ++ lib.optionals stdenv.isDarwin [ xcodebuild ];
  buildInputs = [ libxml2 libxslt zlib ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  # tests are meant to be ran "in-place" in the same directory as src
  doCheck = false;

  pythonImportsCheck = [ "lxml" "lxml.etree" ];

  meta = with lib; {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = "https://lxml.de";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
