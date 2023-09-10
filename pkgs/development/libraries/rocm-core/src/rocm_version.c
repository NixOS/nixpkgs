#include "rocm-core/rocm_version.h"

VerErrors getROCmVersion(unsigned int *Major, unsigned int *Minor,
                         unsigned int *Patch) {
  *Major = @rocm_major@;
  *Minor = @rocm_minor@;
  *Patch = @rocm_patch@;

  return 0;
}
