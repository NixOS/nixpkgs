{
  jax,
  pkgs,
}:

pkgs.writers.writePython3Bin "jax-test-cuda"
  {
    libraries = [
      jax
    ] ++ jax.optional-dependencies.cuda;
  }
  ''
    import jax
    from jax import random

    assert jax.devices()[0].platform == "gpu"

    rng = random.PRNGKey(0)
    x = random.normal(rng, (100, 100))
    x @ x

    print("success!")
  ''
