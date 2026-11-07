with import <nixpkgs> {};

let
  project_name = "pyballista";
  project_version = "0.12.0";

  wheel_tail = "cp38-abi3-linux_x86_64";

  wheel = rustPlatform.buildRustPackage rec {
    pname = project_name;
    version = project_version;

    src = fetchGit {
      url = "https://github.com/apache/arrow-ballista.git";
      rev = "321af95db65a522ae2e618295e1caa77cedf8c13";
    };

    cargoHash = "sha256-/glrPWSsMXtnfC6NNzL7DgWrc9AKDnpYUFIoDXUUoWw=";

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "datafusion-python-35.0.0" = "sha256-p59QAEEMEai4iO+fhd9yaWnGC3sKMj9RThqeSQPEmNg=";
      };
    };

    nativeBuildInputs = [
      protobuf
      maturin
    ];

    doCheck = false;

    postPatch = ''
      cd python
      ln -s ${./Cargo.lock} Cargo.lock
    '';

    buildPhase = ''
      maturin build --target-dir ./target
    '';

    installPhase = ''
      mkdir -p $out
      cp target/wheels/${project_name}-${project_version}-${wheel_tail}.whl $out/
    '';
  };
in
  python3Packages.buildPythonPackage rec {
    pname = project_name;
    version = project_version;

    format = "wheel";

    src = "${wheel}/${project_name}-${project_version}-${wheel_tail}.whl";

    doCheck = false;

    pythonImportChecks = [project_name];

    meta = {
      description = "Python module for Apache Ballista, a distributed compute platform primarily implemented in Rust, largely inspired by Spark, and powered by Apache Arrow.";
      homepage = "https://github.com/apache/arrow-ballista";
      license = lib.licenses.asl20;
      maintainers = ["jhartma"];
      platforms = lib.platforms.all;
    };
  }
