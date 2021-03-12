{ lib, buildPythonPackage, fetchPypi, fetchpatch, cython, libyaml, buildPackages }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "5.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pb4zvkfxfijkpgd1b86xjsqql97ssf1knbd1v53wkg1qm9cgsmq";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-14343.patch";
      url = "https://github.com/yaml/pyyaml/pull/472/commits/7adc0db3f613a82669f2b168edd98379b83adb3c.patch";
      sha256 = "0802zjbp84c7bvja60cv9r9d36x143c62rl01mv35s32r5fids2n";
    })
  ];

  # force regeneration using Cython
  postPatch = ''
    rm ext/_yaml.c
  '';

  nativeBuildInputs = [ cython buildPackages.stdenv.cc ];

  buildInputs = [ libyaml ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = "https://github.com/yaml/pyyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
