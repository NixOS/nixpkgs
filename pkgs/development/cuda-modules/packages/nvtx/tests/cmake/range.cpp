#include <nvtx3/nvtx3.hpp>

int main()
{
    nvtx3::scoped_range range{"range"};
    return 0;
}
