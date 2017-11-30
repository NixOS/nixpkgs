{ stdenv, pkgs, buildPythonPackage, fetchurl, isPy26, argparse, py, selenium }:
buildPythonPackage rec {
  pname = "pytest";
  version = "2.9.2";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/p/pytest/${name}.tar.gz";
    sha256 = "1n6igbc1b138wx1q5gca4pqw1j6nsyicfxds5n0b5989kaxqmh8j";
  };

  # Disabled temporarily because of Hydra issue with namespaces
  doCheck = false;

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  propagatedBuildInputs = [ py ]
    ++ (stdenv.lib.optional isPy26 argparse)
    ++ stdenv.lib.optional
      pkgs.config.pythonPackages.pytest.selenium or false
      selenium;

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar ];
    platforms = platforms.unix;
  };
}
