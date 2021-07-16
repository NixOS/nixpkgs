{ lib, python, fetchPypi, buildPythonPackage, numpy, jre, numpySupport ? true }:

buildPythonPackage rec {
  pname = "jep";
  version = "3.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fM0lqSoZo5FQTnZpQBkL3NTWs6hIjKSjrcjrjNWBwMs=";
  };

  buildInputs = [ jre ];
  propagatedBuildInputs = lib.optional numpySupport numpy;

  preCheck = lib.optional numpySupport ''
    export PYTHONHOME="${python.withPackages(_: [ numpy ])}"
  '';

  postFixup = ''
    cat <<EOF > $out/bin/jep
    #!/bin/sh

    export NIX_PYTHONPATH="$out/${python.sitePackages}:\$NIX_PYTHONPATH"

    if [ -z "\$1" ]
    then
      args="$out/${python.sitePackages}/jep/console.py"
    else
      args=\$*
    fi

    exec ${jre}/bin/java -classpath "$out/${python.sitePackages}/jep/jep-${version}.jar" -Djava.library.path="$out/${python.sitePackages}/jep" jep.Run \$args
    EOF
  '';

  meta = with lib; {
    description = "Tool for embedding CPython in Java through JNI";
    homepage = "https://github.com/ninia/jep";
    license = licenses.libpng;
    maintainers = with maintainers; [ mschuwalow ];
  };
}
