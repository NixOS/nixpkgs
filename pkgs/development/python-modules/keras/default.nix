{ lib, buildPythonPackage, buildBazelPackage, fetchFromGitHub
, bazel_5, tensorflow, python
, pytest, pytest-cov, pytest-xdist
, six, numpy, scipy, pyyaml, h5py
, keras-applications, keras-preprocessing
}:

let
  pname = "keras";
  version = "2.13.1";
in
let
  pythonEnv = python.withPackages (_: [ tensorflow ]);

  git-src = fetchFromGitHub {
    owner = "keras-team";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DHomnFXiTeT7hwTvKU3dZtSGA6bFIb1xFVswCk70BTM=";
  };
in
let
  bazel-build = buildBazelPackage rec {
    inherit pname version;

    bazel = bazel_5;

    postPatch = ''
      rm -f .bazelversion
    '';

    bazelTargets = [
      "'//keras/protobuf:*'"
      "'//keras/api:*'"
    ];

    fetchAttrs = {
      sha256 = "sha256-oBY2VRJGvxVxZRfYJBKSSlO6Zjcxed1CEck+FVIvmvU=";
    };

    buildAttrs = {
      outputs = [ "out" ];

      installPhase = ''
        mkdir -p "$out"
        cp -r "$bazelOut/execroot/org_keras/bazel-out/k8-opt/bin/keras" "$out"
      '';
    };

    nativeBuildInputs = [ pythonEnv ];

    src = git-src;
  };
in buildPythonPackage rec {
  inherit pname version;
  src = git-src;

  postPatch = ''
    ln -s keras/tools/pip_package/setup.py .
    cp -r ${bazel-build}/keras/protobuf/* keras/protobuf
    cp -r ${bazel-build}/keras/api/* keras/api
    touch keras/protobuf/__init__.py
  '';

  buildInputs = [
    tensorflow
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy h5py
    keras-applications keras-preprocessing
  ];

  nativeCheckInputs = [
    tensorflow
  ];

  # Couldn't get bundled tests working
  # Fit a simple model to random data
  checkPhase = ''
    ${python.interpreter} <<EOF
    import tensorflow as tf
    import numpy as np
    np.random.seed(0)
    tf.random.set_seed(0)
    model = tf.keras.models.Sequential([
        tf.keras.layers.Dense(1, activation="linear")
    ])
    model.compile(optimizer="sgd", loss="mse")

    x = np.random.uniform(size=(1,1))
    y = np.random.uniform(size=(1,))
    model.fit(x, y, epochs=1)
    EOF
  '';

  meta = with lib; {
    description = "Deep Learning library for Theano and TensorFlow";
    homepage = "https://keras.io";
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
