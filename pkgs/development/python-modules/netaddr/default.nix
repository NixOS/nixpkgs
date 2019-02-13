{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, fetchpatch
, glibcLocales
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "0.7.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales pytest ];

  checkPhase = ''
    # fails on python3.7: https://github.com/drkjam/netaddr/issues/182
    py.test \
      -k 'not test_ip_splitter_remove_prefix_larger_than_input_range' \
      netaddr/tests
  '';

  patches = [
    (fetchpatch {
      url = https://github.com/drkjam/netaddr/commit/2ab73f10be7069c9412e853d2d0caf29bd624012.patch;
      sha256 = "0s1cdn9v5alpviabhcjmzc0m2pnpq9dh2fnnk2x96dnry1pshg39";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/drkjam/netaddr/;
    description = "A network address manipulation library for Python";
    license = licenses.mit;
  };

}
