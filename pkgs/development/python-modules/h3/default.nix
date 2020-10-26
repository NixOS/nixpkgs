{ stdenv
, buildPythonPackage
, cmake
, fetchPypi
, h3
, python
}:

buildPythonPackage rec {
  pname = "h3";
  version = "3.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "416e35d736ef6ec9c1f73b9d4a9d5c696cc2a7561811f8bcfa08c8c4912f2289";
  };

  patches = [
    ./disable-custom-install.patch
    ./hardcode-h3-path.patch
  ];

  preBuild = ''
    substituteInPlace h3/h3.py \
      --subst-var-by libh3_path ${h3}/lib/libh3${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with stdenv.lib; {
    broken = true;
    homepage = "https://github.com/uber/h3-py";
    description = "This library provides Python bindings for the H3 Core Library.";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = [ maintainers.kalbasit ];
  };
}
