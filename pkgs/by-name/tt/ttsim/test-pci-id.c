// Load a simulator, start it, and read the first endpoint's vendor and device ID
#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if (argc != 3) {
    fprintf(stderr, "usage: %s LIBTTSIM EXPECTED_ID\n", argv[0]);
    return 2;
  }
  void *lib = dlopen(argv[1], RTLD_NOW);
  if (!lib) {
    fprintf(stderr, "%s\n", dlerror());
    return 1;
  }
  void (*init)(void) = (void (*)(void))dlsym(lib, "libttsim_init");
  void (*fini)(void) = (void (*)(void))dlsym(lib, "libttsim_exit");
  uint32_t (*rd)(uint32_t, uint32_t) = (uint32_t (*)(uint32_t, uint32_t))dlsym(lib, "libttsim_pci_config_rd32");
  if (!init || !fini || !rd) {
    fprintf(stderr, "missing libttsim entry point\n");
    return 1;
  }
  init();
  uint32_t id = rd(0, 0);
  fini();
  uint32_t want = (uint32_t)strtoul(argv[2], NULL, 16);
  printf("pci id 0x%08x\n", id);
  return id == want ? 0 : 1;
}
