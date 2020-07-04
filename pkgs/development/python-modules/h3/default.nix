{ stdenv
, buildPythonPackage
, cmake
, fetchPypi
, h3
, python
}:

buildPythonPackage rec {
  pname = "h3";
  version = "3.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7928303e39eb962cfbca38b35e289ddc5e04b0d3ef56532e1747a19450e13263";
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
    homepage = "https://github.com/uber/h3-py";
    description = "This library provides Python bindings for the H3 Core Library.";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = [ maintainers.kalbasit ];
  };
}
