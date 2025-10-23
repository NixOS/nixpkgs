{
  jax,
  pkgs,
}:

pkgs.writers.writePython3Bin "jax-test-cuda"
  {
    libraries = [
      jax
    ]
    ++ jax.optional-dependencies.cuda;
  }
  ''
    import jax
    import jax.numpy as jnp
    from jax import random
    from jax.experimental import sparse

    assert jax.devices()[0].platform == "gpu"  # libcuda.so

    rng = random.key(0)  # libcudart.so, libcudnn.so
    x = random.normal(rng, (100, 100))
    x @ x  # libcublas.so
    jnp.fft.fft(x)  # libcufft.so
    jnp.linalg.inv(x)  # libcusolver.so
    sparse.CSR.fromdense(x) @ x  # libcusparse.so

    print("success!")
  ''
