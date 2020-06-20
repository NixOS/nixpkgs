{ stdenv
, buildPythonPackage
, isPy3k
, isPyPy
, fetchurl
, tkinter
}:

buildPythonPackage rec {
  pname = "namebench";
  version = "1.3.1";
  disabled = isPy3k || isPyPy;

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/{pname}/${pname}-${version}-source.tgz";
    sha256 = "09clbcd6wxgk4r6qw7hb78h818mvca7lijigy1mlq5y1f3lgkk1h";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ tkinter ];

  # namebench expects to be run from its own source tree (it uses relative
  # paths to various resources), make it work.
  postInstall = ''
    sed -i "s|import os|import os; os.chdir(\"$out/namebench\")|" "$out/bin/namebench.py"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/namebench"; # Formerly https://code.google.com/archive/p/namebench/
    description = "Find fastest DNS servers available";
    license = with licenses; [
      asl20
      # third-party program licenses (embedded in the sources)
      lgpl21 # Crystal_Clear
      isc # dns
      bsd3 # jinja2
    ];
    longDescription = ''
      It hunts down the fastest DNS servers available for your computer to
      use. namebench runs a fair and thorough benchmark using your web
      browser history, tcpdump output, or standardized datasets in order
      to provide an individualized recommendation. namebench is completely
      free and does not modify your system in any way.
    '';
  };

}
