{ fetchurl, stdenv, python, setuptools, twisted, makeWrapper, lib }:

stdenv.mkDerivation rec {
  name = "nevow-0.9.33";

  src = fetchurl {
    url = "http://divmod.org/trac/attachment/wiki/SoftwareReleases/Nevow-0.9.33.tar.gz?format=raw";
    sha256 = "1b6zhfxx247b60n1qi2hrawhiaah88v8igg37pf7rjkmvy2z1c6c";
    name = "${name}.tar.gz";
  };

  buildInputs = [ python makeWrapper ];
  propagatedBuildInputs = [ setuptools twisted ];

  doCheck = true;

  buildPhase     = "python setup.py build --build-base $out";
  checkPhase     = "python runtests";

  installPhase   = ''
    ensureDir "$out/lib/python2.5/site-packages"

    PYTHONPATH="$out/lib/python2.5/site-packages:$PYTHONPATH" \
    python setup.py install --prefix="$out"

    ensureDir "$out/doc/${name}"
    cp -rv "doc/"* "$out/doc/${name}"

    ${postInstall}
  '';

  /* FIXME: Wrapping programs like this is not enough:

     $ ./result/bin/nit --help
     Traceback (most recent call last):
       File "/nix/store/p5a9qbdjqcfzqmaya8absvm5279l9wd0-nevow-0.9.33/bin/.wrapped-nit", line 4, in <module>
         import pkg_resources
     [...]
     pkg_resources.DistributionNotFound: Nevow==0.9.33-r17222

    Ideas welcome.  */
  postInstall = ''
    for i in "$out/bin/"*
    do
      wrapProgram "$i"                          \
        --prefix PYTHONPATH ":"                 \
        ${lib.concatStringsSep ":"
           ([ "$out/lib/python2.5/site-packages/src" ] ++
            (map (path: path + "/lib/python2.5/site-packages")
                 (propagatedBuildInputs
                  ++ twisted.propagatedBuildInputs)))}
    done
  '';

  meta = {
    description = "Nevow, a web application construction kit for Python";

    longDescription = ''
      Nevow - Pronounced as the French "nouveau", or "noo-voh", Nevow
      is a web application construction kit written in Python.  It is
      designed to allow the programmer to express as much of the view
      logic as desired in Python, and includes a pure Python XML
      expression syntax named stan to facilitate this.  However it
      also provides rich support for designer-edited templates, using
      a very small XML attribute language to provide bi-directional
      template manipulation capability.

      Nevow also includes formless, a declarative syntax for
      specifying the types of method parameters and exposing these
      methods to the web.  Forms can be rendered automatically, and
      form posts will be validated and input coerced, rendering error
      pages if appropriate.  Once a form post has validated
      successfully, the method will be called with the coerced values.
    '';

    homepage = http://divmod.org/trac/wiki/DivmodNevow;

    license = "BSD-style";
  };
}
