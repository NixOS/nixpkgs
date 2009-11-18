args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/s/sip4-qt3/sip4-qt3_4.7.4.orig.tar.gz;
    sha256 = "0g518b26346q9b0lm13rsgdbq14r4nckyjbf209ylakwx6zir4l5";
  };

  buildInputs = [python];
  configureFlags = [ '' -e "$prefix/include/python$pythonVersion" ''];

  /* doConfigure should be specified separately */
  phaseNames = ["doPythonConfigure" "doMakeInstall"];
      
  name = "python-sip-4.7.4";
  meta = {
    description = "Python/C++ bindings generator";
  };
}
