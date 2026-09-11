// A kernel calling a device function in answer.cu, which requires relocatable device code (-rdc=true).

__device__ int answer();

__global__ void kernel(int *p) { *p = answer(); }

int main() { kernel<<<1, 1>>>(nullptr); }
