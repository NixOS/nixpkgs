{
  lib,
  mlx,
  python,
  runCommand,
  src,
  metalSupport ? false,
}:

{
  mlxTest =
    runCommand "run-mlx${lib.optionalString metalSupport "-bin"}-examples"
      (
        {
          buildInputs = [ mlx ];
          nativeBuildInputs = [ python ];
        }
        // lib.optionalAttrs metalSupport {
          # Access to the Metal device requires running outside the sandbox.
          __noChroot = true;
        }
      )
      (
        lib.optionalString metalSupport ''
          ${python.interpreter} -c 'import mlx.core as mx; assert mx.metal.is_available(), "Metal is unavailable"'
        ''
        + ''
          cp ${src}/examples/python/logistic_regression.py .
          ${python.interpreter} logistic_regression.py
          rm logistic_regression.py

          cp ${src}/examples/python/linear_regression.py .
          ${python.interpreter} linear_regression.py
          rm linear_regression.py

          cp ${src}/benchmarks/python/batch_matmul_bench.py .
          cp ${src}/benchmarks/python/time_utils.py .
          ${python.interpreter} batch_matmul_bench.py ${lib.optionalString metalSupport "--gpu"}
          rm batch_matmul_bench.py time_utils.py

          touch $out
        ''
      );
}
