#undef NDEBUG
#include <cassert>

#include <iostream>

#include <torch/torch.h>

int main() {
  torch::Tensor tensor = torch::eye(3);

  float checkData[] = {
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  };

  torch::Tensor check = torch::from_blob(checkData, {3, 3});

  assert(tensor.allclose(check));
}
