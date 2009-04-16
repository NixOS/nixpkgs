{ fetchurl, stdenv, python, setuptools, twisted, pyopenssl }:

stdenv.mkDerivation rec {
  name = "foolscap-0.3.2";

  src = fetchurl {
    url = "http://foolscap.lothar.com/releases/${name}.tar.gz";
    sha256 = "1wkqgm6anlxvz8dnqx7ki008255nm1mlhak5n9xy6g1yf31fn3l0";
  };

  buildInputs = [ python ];
  propagatedBuildInputs = [ setuptools twisted pyopenssl ];

  doCheck = true;

  buildPhase     = "python setup.py build --build-base $out";
  checkPhase     = "python setup.py test";

  # FIXME: `$out/bin/flogtool' can't find its friends:
  #
  # $ ./result/bin/flogtool --help
  # Traceback (most recent call last):
  #   File "./result/bin/flogtool", line 4, in <module>
  #     import pkg_resources
  # ImportError: No module named pkg_resources

  installPhase   = ''
    ensureDir "$out/lib/python2.5/site-packages"

    PYTHONPATH="$out/lib/python2.5/site-packages:$PYTHONPATH" \
    python setup.py install --prefix="$out"

    ensureDir "$out/doc/${name}"
    cp -rv "doc/"* "$out/doc/${name}"
  '';


  meta = {
    homepage = http://foolscap.lothar.com/;

    description = "Foolscap, an RPC protocol for Python that follows the distributed object-capability model";

    longDescription = ''
      "Foolscap" is the name for the next-generation RPC protocol,
      intended to replace Perspective Broker (part of Twisted).
      Foolscap is a protocol to implement a distributed
      object-capabilities model in Python.
    '';

    # See http://foolscap.lothar.com/trac/browser/LICENSE.
    license = "MIT";
  };
}
