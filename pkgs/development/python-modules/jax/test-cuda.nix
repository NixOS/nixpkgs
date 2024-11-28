{
  jax,
  jaxlib,
  pkgs,
}:

pkgs.writers.writePython3Bin "jax-test-cuda"
  {
    libraries = [
      jax
      jaxlib
    ];
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
