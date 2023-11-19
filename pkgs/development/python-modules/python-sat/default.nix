{ buildPythonPackage, fetchFromGitHub, lib, six, pypblib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-sat";
  version = "0.1.7.dev1";

  src = fetchFromGitHub {
    owner = "pysathq";
    repo = "pysat";
    rev = version;
    hash = "sha256-zGdgD+SgoMB7/zDQI/trmV70l91TB7OkDxaJ30W3dkI=";
  };

  propagatedBuildInputs = [ six pypblib ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://github.com/pysathq/pysat/pull/102
  postPatch = ''
    # Fix for case-insensitive filesystem
    cat >>solvers/patches/cadical.patch <<EOF
diff --git solvers/cadical/VERSION solvers/cdc/VERSION
deleted file mode 100644
--- solvers/cadical/VERSION
+++ /dev/null
@@ -1 +0,0 @@
-1.0.3
EOF
  '';

  meta = with lib; {
    description = "Toolkit to provide interface for various SAT (without optional dependancy py-aiger-cnf)";
    homepage = "https://github.com/pysathq/pysat";
    license = licenses.mit;
    maintainers = [ maintainers.marius851000 ];
  };
}
