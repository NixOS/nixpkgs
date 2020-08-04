{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, Mako
, packaging
, pysocks
, pygments
, ROPGadget
, capstone
, paramiko
, pip
, psutil
, pyelftools
, pyserial
, dateutil
, requests
, tox
, unicorn
, intervaltree
, fetchpatch
}:

buildPythonPackage rec {
  version = "4.2.1";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fh7sq9wrcfvn44qryln9cyg99pilvyq9bp80758lgdd6ss6hdqd";
  };

  # Upstream has set an upper bound on unicorn because of https://github.com/Gallopsled/pwntools/issues/1538,
  # but since that is a niche use case and it requires extra work to get unicorn 1.0.2rc3 to work we relax
  # the bound here. Check if this is still necessary when updating!
  postPatch = ''
    sed -i 's/unicorn>=1.0.2rc1,<1.0.2rc4/unicorn>=1.0.2rc1/' setup.py
  '';

  propagatedBuildInputs = [
    Mako
    packaging
    pysocks
    pygments
    ROPGadget
    capstone
    paramiko
    pip
    psutil
    pyelftools
    pyserial
    dateutil
    requests
    tox
    unicorn
    intervaltree
  ];

  doCheck = false; # no setuptools tests for the package

  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r ];
  };
}
